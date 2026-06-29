# Prompt loading and composition
from pathlib import Path

PROMPTS_DIR = Path(__file__).parent.parent / "prompts"


def load_prompt(name: str) -> str:
    path = PROMPTS_DIR / f"{name}.md"
    if not path.exists():
        raise FileNotFoundError(f"Prompt '{name}' not found at {path}")
    return path.read_text(encoding="utf-8")


def compose_system_prompt(personality: str = "default") -> str:
    system = load_prompt("system_prompt")
    personality_prompt = load_prompt("personality")
    safety = load_prompt("safety")
    return f"{system}\n\n{personality_prompt}\n\n{safety}"
