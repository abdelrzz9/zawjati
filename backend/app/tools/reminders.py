from collections import defaultdict
from datetime import datetime
from .base import BaseTool


class RemindersTool(BaseTool):
    name = "reminders"
    description = "Set or list reminders"
    parameters = {
        "type": "object",
        "properties": {
            "action": {
                "type": "string",
                "enum": ["set", "list", "done"],
                "description": "What to do",
            },
            "text": {
                "type": "string",
                "description": "Reminder text (required for set)",
            },
            "time": {
                "type": "string",
                "description": "When to remind (optional, natural language like 'in 30 minutes')",
            },
        },
        "required": ["action"],
    }

    def __init__(self):
        super().__init__()
        self._reminders: list[dict] = []

    async def execute(self, action: str, text: str = "", time: str = "") -> str:
        match action:
            case "set":
                if not text:
                    return "Error: reminder text is required."
                self._reminders.append({
                    "id": len(self._reminders) + 1,
                    "text": text,
                    "time": time or "as soon as possible",
                    "created": datetime.now().isoformat(),
                    "done": False,
                })
                return f"Reminder set: '{text}' ({time or 'as soon as possible'})"
            case "list":
                active = [r for r in self._reminders if not r["done"]]
                if not active:
                    return "No active reminders."
                lines = [f"[{r['id']}] {r['text']} — {r['time']}" for r in active]
                return "Active reminders:\n" + "\n".join(lines)
            case "done":
                if not text.isdigit():
                    return "Error: provide the reminder ID number to mark as done."
                rid = int(text)
                for r in self._reminders:
                    if r["id"] == rid:
                        r["done"] = True
                        return f"Reminder '{r['text']}' marked as done."
                return f"Reminder #{rid} not found."
            case _:
                return f"Unknown action: {action}"
