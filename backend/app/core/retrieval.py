from typing import Optional
from ..store.base import MemoryStore
from ..store.conversation import ConversationStore
from ..store.profile import ProfileStore
from ..models import MemoryEntry
from ..observability.logger import timer


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
        with timer() as conv_t:
            history = self.conversation.get_history(user_id, limit=50)

        with timer() as epi_t:
            episodic = await self.episodic.query(user_id, query, limit=5)

        with timer() as sem_t:
            semantic = await self.semantic.query(user_id, query, limit=10)

        with timer() as prof_t:
            profile = await self.profile.get(user_id)

        return {
            "history": history,
            "episodic": episodic,
            "semantic": semantic,
            "profile": profile,
            "timing_ms": {
                "conversation": conv_t["elapsed"],
                "episodic": epi_t["elapsed"],
                "semantic": sem_t["elapsed"],
                "profile": prof_t["elapsed"],
            },
        }

    @staticmethod
    def format_memories(entries: list[MemoryEntry]) -> str:
        if not entries:
            return ""
        lines = []
        for e in entries:
            prefix = ""
            if e.importance >= 8:
                prefix = "[IMPORTANT] "
            elif e.confidence >= 0.9:
                prefix = "[HIGH CONFIDENCE] "
            lines.append(f"- {prefix}{e.content}")
        return "\n".join(lines)
