from pathlib import Path
from typing import Optional

PERSONALITIES_DIR = Path(__file__).parent.parent.parent / "prompts" / "personalities"


class PersonalityEngine:
    def __init__(self):
        self._cache: dict[str, str] = {}

    def load_personality(self, name: str) -> str:
        if name in self._cache:
            return self._cache[name]

        path = PERSONALITIES_DIR / f"{name}.md"
        if not path.exists():
            available = self.list_personalities()
            raise FileNotFoundError(
                f"Personality '{name}' not found. Available: {available}"
            )

        content = path.read_text(encoding="utf-8")
        self._cache[name] = content
        return content

    def list_personalities(self) -> list[str]:
        if not PERSONALITIES_DIR.exists():
            return []
        return sorted(p.stem for p in PERSONALITIES_DIR.iterdir() if p.suffix == ".md")

    def reload(self, name: str):
        self._cache.pop(name, None)
