from collections import defaultdict
from typing import Optional
from .base import MemoryStore
from ..models import MemoryEntry


class SemanticMemory(MemoryStore):
    def __init__(self):
        self._store: dict[str, list[MemoryEntry]] = defaultdict(list)

    async def add(self, user_id: str, entry: MemoryEntry):
        existing = self._find_by_key(user_id, entry.content)
        if existing:
            existing.importance = max(existing.importance, entry.importance)
            existing.timestamp = entry.timestamp
            return
        self._store[user_id].append(entry)

    async def add_batch(self, user_id: str, entries: list[MemoryEntry]):
        for e in entries:
            await self.add(user_id, e)

    def _find_by_key(self, user_id: str, content: str) -> Optional[MemoryEntry]:
        for e in self._store.get(user_id, []):
            if e.content.lower() == content.lower():
                return e
        return None

    async def query(self, user_id: str, query: str, limit: int = 10) -> list[MemoryEntry]:
        entries = self._store.get(user_id, [])
        query_lower = query.lower()
        scored = []
        for e in entries:
            score = 0
            if query_lower in e.content.lower():
                score += e.importance * 2
            words = query_lower.split()
            matches = sum(1 for w in words if w in e.content.lower())
            score += matches
            if score > 0:
                scored.append((score, e))
        scored.sort(key=lambda x: x[0], reverse=True)
        return [e for _, e in scored[:limit]]

    async def get_by_category(self, user_id: str, category: str, limit: int = 20) -> list[MemoryEntry]:
        return [e for e in self._store.get(user_id, []) if e.category == category][-limit:]

    async def clear(self, user_id: str):
        self._store[user_id] = []
