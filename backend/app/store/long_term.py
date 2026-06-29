from collections import defaultdict
from typing import Optional
from ..models import MemoryEntry


class LongTermMemory:
    def __init__(self):
        self._memories: dict[str, list[MemoryEntry]] = defaultdict(list)

    def store(self, entry: MemoryEntry):
        self._memories[entry.user_id].append(entry)

    def retrieve(self, user_id: str, category: Optional[str] = None, limit: int = 20) -> list[MemoryEntry]:
        entries = self._memories[user_id]
        if category:
            entries = [e for e in entries if e.category == category]
        return entries[-limit:]

    def format_for_prompt(self, user_id: str) -> str:
        entries = self.retrieve(user_id)
        if not entries:
            return ""
        lines = [f"- {e.key}: {e.value}" for e in entries]
        return "Things I know about the user:\n" + "\n".join(lines)
