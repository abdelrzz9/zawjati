from typing import AsyncIterator, Optional
from datetime import datetime

from ..models import ChatRequest, LLMResponse, MemoryEntry
from ..llm.base import LLMProvider
from ..store.conversation import ConversationStore
from ..store.profile import ProfileStore
from ..store.base import MemoryStore
from ..tools.registry import ToolRegistry
from ..core.personality import PersonalityEngine
from ..core.prompt_builder import PromptBuilder
from ..core.retrieval import RetrievalPipeline
from ..observability.logger import ObservabilityLogger, TraceMetrics, timer
from ..observability.metrics import MetricsCollector, RequestMetrics


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

    async def process_message(self, req: ChatRequest) -> str:
        metrics = TraceMetrics()
        with timer() as rt:
            profile = await self.profile.get(req.user_id)
            active_personality = req.personality or profile.personality

            personality_content = self.personalities.load_personality(active_personality)

            with timer() as mem_timer:
                retrieved = await self.retrieval.retrieve(req.user_id, req.message)
            metrics.memory_retrieval_ms = mem_timer["elapsed"]

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

            history = self.conversation.get_history(req.user_id)
            messages = [
                {"role": "system", "content": system_prompt},
                *history,
                {"role": "user", "content": req.message},
            ]

            openai_tools = self.tools.get_openai_tools()

            with timer() as llm_timer:
                response = await self.llm.chat(messages, tools=openai_tools or None)
            metrics.latency_ms = llm_timer["elapsed"]
            metrics.prompt_tokens = response.usage.prompt_tokens
            metrics.completion_tokens = response.usage.completion_tokens
            metrics.cost = response.usage.cost
            metrics.model = response.usage.model

            reply = response.content

            if response.tool_calls:
                with timer() as tool_timer:
                    for tc in response.tool_calls:
                        import json
                        try:
                            args = json.loads(tc["arguments"])
                        except json.JSONDecodeError:
                            args = {}
                        tool_result = await self.tools.execute(tc["name"], args)
                        reply += f"\n\n[Used tool: {tc['name']} → {tool_result}]"
                metrics.tool_execution_ms = tool_timer["elapsed"]

            self.conversation.add_turn(req.user_id, "user", req.message)
            self.conversation.add_turn(req.user_id, "assistant", reply)

        await self._extract_and_store_memories(req.user_id, req.message, reply)

        self.logger.log_chat(req.user_id, metrics)
        self.metrics.record(RequestMetrics(
            latency_ms=metrics.latency_ms,
            prompt_tokens=metrics.prompt_tokens,
            completion_tokens=metrics.completion_tokens,
            cost=metrics.cost,
            model=metrics.model,
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
        await self._extract_and_store_memories(req.user_id, req.message, full_reply)

    async def _extract_and_store_memories(self, user_id: str, user_msg: str, assistant_reply: str):
        import re
        patterns = [
            r"(?:my|I) (?:favorite|love|like|enjoy|hate|dislike) (\w+)",
            r"(?:I am|I'm) (\w+)",
            r"(?:my|I have a) (\w+)",
        ]
        for pattern in patterns:
            for match in re.finditer(pattern, user_msg.lower()):
                entry = MemoryEntry(
                    content=f"User mentioned: {match.group(0)}",
                    user_id=user_id,
                    category="preference" if "favorite" in pattern or "like" in pattern else "fact",
                    importance=5,
                )
                await self.semantic.add(user_id, entry)
