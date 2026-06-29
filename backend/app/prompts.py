from pathlib import Path
from typing import Optional

PROMPTS_DIR = Path(__file__).parent.parent / "prompts"


def load_prompt(name: str) -> str:
    path = PROMPTS_DIR / f"{name}.md"
    if not path.exists():
        raise FileNotFoundError(f"Prompt '{name}' not found at {path}")
    return path.read_text(encoding="utf-8")


def compose_system_prompt(
    personality: str = "default",
    nickname: Optional[str] = None,
    relationship_type: str = "companion",
    memories: Optional[str] = None,
) -> str:
    parts = [load_prompt("system_prompt")]

    ctx_lines = [f"Your relationship type is: {relationship_type}."]
    if nickname:
        ctx_lines.append(f'The user goes by "{nickname}". Use it naturally and sparingly.')
    parts.append("## Context\n" + "\n".join(ctx_lines))

    parts.append(load_prompt("personality"))
    parts.append(load_prompt("safety"))

    if personality != "default":
        profile_path = PROMPTS_DIR / "profiles" / f"{personality}.md"
        if profile_path.exists():
            parts.append(profile_path.read_text(encoding="utf-8"))

    if memories:
        parts.append(f"## User Memories\n{memories}")

    return "\n\n".join(parts)
