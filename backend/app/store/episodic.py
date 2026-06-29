from collections import defaultdict
from typing import Optional
from .base import MemoryStore
from ..models import MemoryEntry


class EpisodicMemory(MemoryStore):
    def __init__(self):
        self._store: dict[str, list[MemoryEntry]] = defaultdict(list)

    async def add(self, user_id: str, entry: MemoryEntry):
        self._store[user_id].append(entry)

    async def add_batch(self, user_id: str, entries: list[MemoryEntry]):
        self._store[user_id].extend(entries)

    async def query(self, user_id: str, query: str, limit: int = 10) -> list[MemoryEntry]:
        entries = self._store.get(user_id, [])
        query_lower = query.lower()
        scored = []
        for e in entries:
            score = 0
            if query_lower in e.content.lower():
                score += e.importance
                if e.category == "event":
                    score += 2
            if score > 0:
                scored.append((score, e))
        scored.sort(key=lambda x: x[0], reverse=True)
        return [e for _, e in scored[:limit]]

    async def get_by_category(self, user_id: str, category: str, limit: int = 20) -> list[MemoryEntry]:
        return [e for e in self._store.get(user_id, []) if e.category == category][-limit:]

    async def clear(self, user_id: str):
        self._store[user_id] = []
