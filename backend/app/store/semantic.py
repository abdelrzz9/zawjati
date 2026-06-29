from collections import defaultdict
from datetime import datetime
from typing import Optional
from .base import MemoryStore
from ..models import MemoryEntry


class SemanticMemory(MemoryStore):
    def __init__(self):
        self._store: dict[str, list[MemoryEntry]] = defaultdict(list)

    async def add(self, user_id: str, entry: MemoryEntry):
        existing = self._find_similar(user_id, entry.content)
        if existing:
            existing.importance = max(existing.importance, entry.importance)
            existing.confidence = max(existing.confidence, entry.confidence)
            existing.timestamp = entry.timestamp
            existing.access_count += 1
            return
        self._store[user_id].append(entry)

    async def add_batch(self, user_id: str, entries: list[MemoryEntry]):
        for e in entries:
            await self.add(user_id, e)

    def _find_similar(self, user_id: str, content: str) -> Optional[MemoryEntry]:
        content_lower = content.lower().strip()
        for e in self._store.get(user_id, []):
            if e.content.lower().strip() == content_lower:
                return e
            words = set(content_lower.split())
            e_words = set(e.content.lower().split())
            if len(words & e_words) / max(len(words | e_words), 1) > 0.7:
                return e
        return None

    async def query(self, user_id: str, query: str, limit: int = 10) -> list[MemoryEntry]:
        entries = self._store.get(user_id, [])
        now = datetime.now()
        scored = []

        for e in entries:
            score = 0.0
            e.last_accessed = now

            query_lower = query.lower()
            content_lower = e.content.lower()

            if query_lower in content_lower:
                score += e.importance * 2.0

            query_words = query_lower.split()
            content_words = content_lower.split()
            matches = sum(1 for w in query_words if w in content_words)
            score += matches * 0.8

            recency_hours = (now - e.timestamp).total_seconds() / 3600
            recency_boost = max(0, 2.0 - recency_hours / 48)
            score += recency_boost

            score *= e.confidence
            if score > 0:
                scored.append((score, e))

        scored.sort(key=lambda x: x[0], reverse=True)
        results = [e for _, e in scored[:limit]]
        for e in results:
            e.access_count += 1
        return results

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
