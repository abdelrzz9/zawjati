from typing import Optional
from ..store.base import MemoryStore
from ..store.conversation import ConversationStore
from ..store.profile import ProfileStore


class RetrievalPipeline:
    def __init__(
        self,
        conversation_store: ConversationStore,
        episodic_store: MemoryStore,
        semantic_store: MemoryStore,
        profile_store: ProfileStore,
    ):
        self.conversation = conversation_store
        self.episodic = episodic_store
        self.semantic = semantic_store
        self.profile = profile_store

    async def retrieve(self, user_id: str, query: str) -> dict:
        history = self.conversation.get_history(user_id, limit=50)

        episodic = await self.episodic.query(user_id, query, limit=5)
        semantic = await self.semantic.query(user_id, query, limit=10)

        episodic.sort(key=lambda e: e.importance, reverse=True)
        semantic.sort(key=lambda e: e.importance, reverse=True)

        profile = await self.profile.get(user_id)

        return {
            "history": history,
            "episodic": episodic,
            "semantic": semantic,
            "profile": profile,
        }

    @staticmethod
    def format_memories(entries: list) -> str:
        if not entries:
            return ""
        lines = []
        for e in entries:
            prefix = "[IMPORTANT] " if e.importance >= 7 else ""
            lines.append(f"- {prefix}{e.content}")
        return "\n".join(lines)
