from collections import defaultdict
from ..models import ConversationTurn


class ConversationStore:
    def __init__(self):
        self._history: dict[str, list[ConversationTurn]] = defaultdict(list)

    def add_turn(self, user_id: str, role: str, content: str):
        self._history[user_id].append(ConversationTurn(role=role, content=content))

    def get_history(self, user_id: str, limit: int = 50) -> list[dict]:
        turns = self._history[user_id][-limit:]
        return [{"role": t.role, "content": t.content} for t in turns]

    def get_recent(self, user_id: str, n: int = 5) -> list[ConversationTurn]:
        return self._history[user_id][-n:]

    def clear(self, user_id: str):
        self._history[user_id] = []

    def build_summary(self, user_id: str, n: int = 10) -> str:
        turns = self.get_recent(user_id, n)
        if not turns:
            return ""
        lines = []
        for t in turns:
            label = "User" if t.role == "user" else "Assistant"
            preview = t.content[:100] + "..." if len(t.content) > 100 else t.content
            lines.append(f"{label}: {preview}")
        return "Recent conversation:\n" + "\n".join(lines)
