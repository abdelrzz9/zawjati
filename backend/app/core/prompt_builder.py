from pathlib import Path
from datetime import datetime
from typing import Optional

PROMPTS_DIR = Path(__file__).parent.parent.parent / "prompts"


class PromptBuilder:
    def __init__(self):
        self._cache: dict[str, str] = {}

    def _load(self, name: str) -> str:
        if name in self._cache:
            return self._cache[name]
        path = PROMPTS_DIR / f"{name}.md"
        if path.exists():
            content = path.read_text(encoding="utf-8")
            self._cache[name] = content
            return content
        return ""

    def build(
        self,
        personality: str,
        personality_content: str,
        nickname: Optional[str] = None,
        relationship_type: str = "companion",
        memories: Optional[str] = None,
        conversation_summary: Optional[str] = None,
    ) -> str:
        now = datetime.now()
        date_str = now.strftime("%A, %B %d, %Y at %I:%M %p")

        sections = []

        base = self._load("base")
        if base:
            sections.append(base)

        sections.append(f"# Date & Time\nCurrent date and time: {date_str}.")

        context_lines = [f"Relationship type: {relationship_type}."]
        if nickname:
            context_lines.append(f'The user goes by "{nickname}". Use it naturally and sparingly.')
        sections.append("# Context\n" + "\n".join(context_lines))

        sections.append(personality_content)

        safety = self._load("safety")
        if safety:
            sections.append(safety)

        if memories:
            sections.append(f"# Things I Know About the User\n{memories}")

        if conversation_summary:
            sections.append(f"# Conversation Summary\n{conversation_summary}")

        return "\n\n".join(sections)

    def reload(self):
        self._cache.clear()
