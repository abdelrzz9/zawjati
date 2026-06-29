# Contributing

## Development Setup

```bash
git clone <repo>
cd zawjati
python -m venv .venv
source .venv/bin/activate
pip install -r backend/requirements.txt
cp backend/.env.example backend/.env
# Edit .env with your API key
```

## Running

```bash
cd backend
uvicorn app.main:app --reload
```

## Testing

```bash
cd zawjati
python -m pytest tests/ -v
```

## Adding a Personality

Create a markdown file in `backend/prompts/personalities/`:

```markdown
# Personality: Coach

You are motivating, energetic, and goal-oriented. You push the user to be their best self...
```

## Adding a Tool

1. Create a file in `backend/app/tools/`
2. Subclass `BaseTool`
3. Define `name`, `description`, `parameters` (OpenAI function-calling format)
4. Implement `async def execute(self, **kwargs)`
5. Register in `backend/app/api/deps.py`

```python
from app.tools.base import BaseTool

class MyTool(BaseTool):
    name = "my_tool"
    description = "Does something useful"
    parameters = {
        "type": "object",
        "properties": {
            "input": {"type": "string"}
        },
        "required": ["input"],
    }

    async def execute(self, input: str) -> str:
        return f"Processed: {input}"
```

## Code Style

- No type annotations in function bodies that are already in signatures
- Async-first for all I/O
- Core business logic in `app/core/` — no framework imports
- Tests use mock providers, never real API keys
