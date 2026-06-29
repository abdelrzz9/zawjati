from .models import ChatRequest
from .prompts import compose_system_prompt
from .llm import LLMClient
from .store.conversation import ConversationStore
from .store.long_term import LongTermMemory
from .tools import ToolRegistry


class ChatService:
    def __init__(
        self,
        llm: LLMClient,
        conversation_store: ConversationStore,
        memory_store: LongTermMemory,
        tool_registry: ToolRegistry,
    ):
        self.llm = llm
        self.conversation = conversation_store
        self.memory = memory_store
        self.tools = tool_registry

    async def handle_message(
        self,
        req: ChatRequest,
        nickname: str | None = None,
        relationship_type: str = "companion",
        personality: str = "default",
    ) -> str:
        active_personality = req.personality or personality
        memories = self.memory.format_for_prompt(req.user_id)

        system = compose_system_prompt(
            personality=active_personality,
            nickname=nickname,
            relationship_type=relationship_type,
            memories=memories,
        )

        history = self.conversation.get_history(req.user_id)
        messages = [
            {"role": "system", "content": system},
            *history,
            {"role": "user", "content": req.message},
        ]

        tools = self.tools.get_openai_tools()
        reply = await self.llm.chat(messages, tools=tools if tools else None)

        self.conversation.add_turn(req.user_id, "user", req.message)
        self.conversation.add_turn(req.user_id, "assistant", reply)

        return reply
