from collections import defaultdict
from datetime import datetime
from .base import BaseTool


class NotesTool(BaseTool):
    name = "notes"
    description = "Save or retrieve personal notes"
    parameters = {
        "type": "object",
        "properties": {
            "action": {
                "type": "string",
                "enum": ["save", "get", "list", "delete"],
                "description": "What to do with the note",
            },
            "title": {
                "type": "string",
                "description": "Note title (required for save, get, delete)",
            },
            "content": {
                "type": "string",
                "description": "Note content (required for save)",
            },
        },
        "required": ["action"],
    }

    def __init__(self):
        super().__init__()
        self._notes: dict[str, dict] = {}

    async def execute(self, action: str, title: str = "", content: str = "") -> str:
        match action:
            case "save":
                if not title or not content:
                    return "Error: title and content are required for saving."
                self._notes[title] = {
                    "content": content,
                    "created": datetime.now().isoformat(),
                }
                return f"Note '{title}' saved."
            case "get":
                note = self._notes.get(title)
                if not note:
                    return f"Note '{title}' not found."
                return f"**{title}**\n{note['content']}\n*Created: {note['created']}*"
            case "list":
                if not self._notes:
                    return "No notes saved."
                titles = "\n".join(f"- {t}" for t in self._notes)
                return f"Saved notes:\n{titles}"
            case "delete":
                if title in self._notes:
                    del self._notes[title]
                    return f"Note '{title}' deleted."
                return f"Note '{title}' not found."
            case _:
                return f"Unknown action: {action}"
