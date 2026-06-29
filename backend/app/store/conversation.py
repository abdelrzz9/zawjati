from collections import defaultdict
from ..models import ConversationTurn


class ConversationStore:
    def __init__(self):
        self._history: dict[str, list[ConversationTurn]] = defaultdict(list)

    def add_turn(self, user_id: str, role: str, content: str):
        turn = ConversationTurn(role=role, content=content)
        self._history[user_id].append(turn)

    def get_history(self, user_id: str, limit: int = 50) -> list[dict]:
        turns = self._history[user_id][-limit:]
        return [{"role": t.role, "content": t.content} for t in turns]

    def clear(self, user_id: str):
        self._history[user_id] = []
