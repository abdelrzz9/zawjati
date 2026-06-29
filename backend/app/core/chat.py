import re
import json
from typing import AsyncIterator, Optional
from uuid import uuid4

from ..models import ChatRequest, MemoryEntry
from ..llm.base import LLMProvider, LLMProviderError
from ..store.conversation import ConversationStore
from ..store.profile import ProfileStore
from ..store.base import MemoryStore
from ..tools.registry import ToolRegistry
from ..core.personality import PersonalityEngine
from ..core.prompt_builder import PromptBuilder
from ..core.retrieval import RetrievalPipeline
from ..observability.logger import ObservabilityLogger, TraceMetrics, timer
from ..observability.metrics import MetricsCollector, RequestMetrics
from ..config import settings


class ChatOrchestrator:
    def __init__(
        self,
        llm: LLMProvider,
        conversation_store: ConversationStore,
        episodic_store: MemoryStore,
        semantic_store: MemoryStore,
        profile_store: ProfileStore,
        tool_registry: ToolRegistry,
        personality_engine: PersonalityEngine,
        logger: Optional[ObservabilityLogger] = None,
        metrics: Optional[MetricsCollector] = None,
    ):
        self.llm = llm
        self.conversation = conversation_store
        self.episodic = episodic_store
        self.semantic = semantic_store
        self.profile = profile_store
        self.tools = tool_registry
        self.personalities = personality_engine
        self.logger = logger or ObservabilityLogger()
        self.metrics = metrics or MetricsCollector()
        self.prompt_builder = PromptBuilder()
        self.retrieval = RetrievalPipeline(
            conversation_store, episodic_store, semantic_store, profile_store
        )

    async def process_message(self, req: ChatRequest, request_id: str = "") -> str:
        metrics = TraceMetrics()

        profile = await self.profile.get(req.user_id)
        active_personality = req.personality or profile.personality

        personality_content = self.personalities.load_personality(active_personality)

        with timer() as mem_timer:
            retrieved = await self.retrieval.retrieve(req.user_id, req.message)
        metrics.memory_retrieval_ms = mem_timer["elapsed"]

        episodic_str = RetrievalPipeline.format_memories(retrieved["episodic"])
        semantic_str = RetrievalPipeline.format_memories(retrieved["semantic"])
        all_memories = "\n".join(filter(None, [episodic_str, semantic_str]))

        with timer() as prompt_timer:
            system_prompt = self.prompt_builder.build(
                personality=active_personality,
                personality_content=personality_content,
                nickname=retrieved["profile"].nickname,
                relationship_type=retrieved["profile"].relationship_type.value,
                memories=all_memories or None,
                conversation_summary=self.conversation.build_summary(req.user_id, n=5),
            )
            system_prompt = self.prompt_builder.trim_to_fit(
                system_prompt, max_tokens=settings.max_context_tokens
            )
        metrics.prompt_construction_ms = prompt_timer["elapsed"]

        history = self.conversation.get_history(req.user_id)
        messages = [
            {"role": "system", "content": system_prompt},
            *history,
            {"role": "user", "content": req.message},
        ]

        openai_tools = self.tools.get_openai_tools() if settings.enable_tool_calling else []

        with timer() as llm_timer:
            response = await self.llm.chat(
                messages, tools=openai_tools or None
            )
        metrics.latency_ms = llm_timer["elapsed"]
        metrics.prompt_tokens = response.usage.prompt_tokens
        metrics.completion_tokens = response.usage.completion_tokens
        metrics.total_tokens = response.usage.total_tokens
        metrics.cost = response.usage.cost
        metrics.model = response.usage.model
        metrics.provider = response.usage.provider

        reply = response.content

        if response.tool_calls:
            with timer() as tool_timer:
                for tc in response.tool_calls:
                    try:
                        args = json.loads(tc["arguments"])
                    except json.JSONDecodeError:
                        args = {}
                    tool_result = await self.tools.execute(tc["name"], args)
                    safe_result = self._sanitize_tool_output(tool_result)
                    reply += f"\n\n[Used tool: {tc['name']}]"
            metrics.tool_execution_ms = tool_timer["elapsed"]

        self.conversation.add_turn(req.user_id, "user", req.message)
        self.conversation.add_turn(req.user_id, "assistant", reply)

        if settings.enable_memory:
            await self._extract_and_store_memories(req.user_id, req.message, reply)

        self.logger.log_chat(req.user_id, metrics, request_id)
        self.metrics.record(RequestMetrics(
            latency_ms=metrics.latency_ms,
            prompt_tokens=metrics.prompt_tokens,
            completion_tokens=metrics.completion_tokens,
            total_tokens=metrics.total_tokens,
            cost=metrics.cost,
            model=metrics.model,
            provider=metrics.provider,
        ))

        return reply

    async def process_message_stream(self, req: ChatRequest) -> AsyncIterator[str]:
        profile = await self.profile.get(req.user_id)
        active_personality = req.personality or profile.personality
        personality_content = self.personalities.load_personality(active_personality)

        retrieved = await self.retrieval.retrieve(req.user_id, req.message)
        episodic_str = RetrievalPipeline.format_memories(retrieved["episodic"])
        semantic_str = RetrievalPipeline.format_memories(retrieved["semantic"])
        all_memories = "\n".join(filter(None, [episodic_str, semantic_str]))

        system_prompt = self.prompt_builder.build(
            personality=active_personality,
            personality_content=personality_content,
            nickname=retrieved["profile"].nickname,
            relationship_type=retrieved["profile"].relationship_type.value,
            memories=all_memories or None,
            conversation_summary=self.conversation.build_summary(req.user_id, n=5),
        )
        system_prompt = self.prompt_builder.trim_to_fit(
            system_prompt, max_tokens=settings.max_context_tokens
        )

        history = self.conversation.get_history(req.user_id)
        messages = [
            {"role": "system", "content": system_prompt},
            *history,
            {"role": "user", "content": req.message},
        ]

        self.conversation.add_turn(req.user_id, "user", req.message)

        full_reply = ""
        async for chunk in self.llm.chat_stream(messages):
            full_reply += chunk
            yield chunk

        self.conversation.add_turn(req.user_id, "assistant", full_reply)
        if settings.enable_memory:
            await self._extract_and_store_memories(req.user_id, req.message, full_reply)

    async def _extract_and_store_memories(self, user_id: str, user_msg: str, assistant_reply: str):
        memory_blocks = re.findall(
            r"---MEMORY:\s*(\w+)\s*\|\s*(.+?)\s*\|\s*importance=(\d+)\s*\|\s*confidence=([\d.]+)",
            assistant_reply,
        )
        for category, content, importance, confidence in memory_blocks:
            if category not in {"preference", "fact", "goal", "event", "concept", "relationship", "achievement", "routine", "opinion"}:
                category = "fact"
            entry = MemoryEntry(
                content=content.strip(),
                user_id=user_id,
                category=category,  # type: ignore
                importance=int(importance),
                confidence=float(confidence),
            )
            await self.semantic.add(user_id, entry)

        preference_patterns = [
            (r"(?:my|I) (?:favorite|love|like|enjoy|prefer) (\w+(?:\s+\w+){0,3})", "preference"),
            (r"(?:I am|I'm) (\w+(?:\s+\w+){0,3})", "fact"),
            (r"(?:I want to|I plan to|I hope to|my goal is to) (\w+(?:\s+\w+){0,5})", "goal"),
        ]
        for pattern, category in preference_patterns:
            for match in re.finditer(pattern, user_msg.lower()):
                for existing in self._existing_memories(user_id, match.group(0)):
                    existing.access_count += 1
                    existing.last_accessed = __import__("datetime").datetime.now()
                    break
                else:
                    entry = MemoryEntry(
                        content=match.group(0).strip(),
                        user_id=user_id,
                        category=category,  # type: ignore
                        importance=4,
                        confidence=0.6,
                    )
                    await self.semantic.add(user_id, entry)

    def _existing_memories(self, user_id: str, content: str) -> list:
        import asyncio
        try:
            loop = asyncio.get_event_loop()
            if loop.is_running():
                return []
        except RuntimeError:
            pass
        return []

    def _sanitize_tool_output(self, output: str) -> str:
        if not output:
            return ""
        output = re.sub(r"[<>]", "", output)
        output = re.sub(r"\s+", " ", output).strip()
        return output[:500]

    async def handle_tool_loop(self, messages: list, tools: list) -> tuple[str, list[dict]]:
        all_tool_calls = []
        while True:
            response = await self.llm.chat(messages, tools=tools or None)
            if not response.tool_calls:
                return response.content, all_tool_calls

            for tc in response.tool_calls:
                try:
                    args = json.loads(tc["arguments"])
                except json.JSONDecodeError:
                    args = {}
                result = await self.tools.execute(tc["name"], args)
                safe = self._sanitize_tool_output(result)
                messages.append({
                    "role": "assistant",
                    "content": None,
                    "tool_calls": [{"id": tc.get("id", ""), "type": "function", "function": tc}],
                })
                messages.append({
                    "role": "tool",
                    "tool_call_id": tc.get("id", ""),
                    "content": safe,
                })
                all_tool_calls.append(tc)
