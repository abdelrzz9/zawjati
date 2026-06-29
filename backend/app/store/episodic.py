from collections import defaultdict
from datetime import datetime, timedelta
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
        now = datetime.now()
        scored = []

        for e in entries:
            score = 0.0
            e.last_accessed = now
            e.access_count += 1

            query_lower = query.lower()
            content_lower = e.content.lower()

            if query_lower in content_lower:
                score += e.importance * 1.5

            query_words = set(query_lower.split())
            content_words = set(content_lower.split())
            common = query_words & content_words
            score += len(common) * 0.5

            if e.category == "event":
                score += 1.0

            recency_hours = (now - e.timestamp).total_seconds() / 3600
            recency_boost = max(0, 3.0 - recency_hours / 24)

            access_boost = min(e.access_count * 0.1, 2.0)

            if score > 0:
                score += recency_boost
                score += access_boost
                score *= e.confidence
                scored.append((score, e))

        scored.sort(key=lambda x: x[0], reverse=True)
        return [e for _, e in scored[:limit]]

    async def get_by_category(self, user_id: str, category: str, limit: int = 20) -> list[MemoryEntry]:
        return [e for e in self._store.get(user_id, []) if e.category == category][-limit:]

    async def get_by_id(self, user_id: str, memory_id: str) -> Optional[MemoryEntry]:
        for e in self._store.get(user_id, []):
            if e.id == memory_id:
                return e
        return None

    async def update(self, user_id: str, entry: MemoryEntry):
        for i, e in enumerate(self._store.get(user_id, [])):
            if e.id == entry.id:
                self._store[user_id][i] = entry
                return

    async def delete(self, user_id: str, memory_id: str):
        self._store[user_id] = [e for e in self._store.get(user_id, []) if e.id != memory_id]

    async def clear(self, user_id: str):
        self._store[user_id] = []

    async def get_all(self, user_id: str) -> list[MemoryEntry]:
        return list(self._store.get(user_id, []))
