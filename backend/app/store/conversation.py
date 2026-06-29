from collections import defaultdict
from datetime import datetime
from typing import Optional
from ..models import ConversationTurn
from ..config import settings


class ConversationStore:
    def __init__(self):
        self._history: dict[str, list[ConversationTurn]] = defaultdict(list)
        self._summaries: dict[str, str] = {}

    def add_turn(self, user_id: str, role: str, content: str):
        turn = ConversationTurn(role=role, content=content)
        self._history[user_id].append(turn)
        self._check_and_trim(user_id)

    def _check_and_trim(self, user_id: str):
        turns = self._history[user_id]
        if len(turns) > settings.max_history_messages:
            excess = turns[:-settings.max_history_messages]
            old_summary = self._summaries.get(user_id, "")
            new_summary = self._summarize_turns(excess)
            combined = f"{old_summary}\n{new_summary}".strip()
            self._summaries[user_id] = combined
            self._history[user_id] = turns[-settings.max_history_messages:]

        total = sum(len(t.content) for t in self._history[user_id])
        if total > settings.max_history_characters:
            while total > settings.max_history_characters and len(self._history[user_id]) > 10:
                removed = self._history[user_id].pop(0)
                total -= len(removed.content)

    def _summarize_turns(self, turns: list[ConversationTurn]) -> str:
        lines = []
        for t in turns:
            label = "User" if t.role == "user" else "Assistant"
            preview = t.content[:80].replace("\n", " ")
            if len(t.content) > 80:
                preview += "..."
            lines.append(f"{label}: {preview}")
        return "Conversation history:\n" + "\n".join(lines)

    def get_history(self, user_id: str, limit: Optional[int] = None) -> list[dict]:
        limit = limit or settings.max_history_messages
        turns = self._history[user_id][-limit:]
        return [{"role": t.role, "content": t.content} for t in turns]

    def get_recent(self, user_id: str, n: int = 5) -> list[ConversationTurn]:
        return self._history[user_id][-n:]

    def clear(self, user_id: str):
        self._history[user_id] = []
        self._summaries.pop(user_id, None)

    def build_summary(self, user_id: str, n: int = 10) -> str:
        summary = self._summaries.get(user_id, "")
        recent = self.get_recent(user_id, n)
        if recent:
            lines = []
            for t in recent:
                label = "User" if t.role == "user" else "Assistant"
                preview = t.content[:120].replace("\n", " ")
                if len(t.content) > 120:
                    preview += "..."
                lines.append(f"{label}: {preview}")
            recent_str = "Recent messages:\n" + "\n".join(lines)
        else:
            recent_str = ""

        if summary and recent_str:
            return f"{summary}\n\n{recent_str}"
        return summary or recent_str

    def total_turns(self, user_id: str) -> int:
        return len(self._history[user_id])
