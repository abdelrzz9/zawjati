from typing import Any, Callable, Awaitable

ToolHandler = Callable[..., Awaitable[str]]


class Tool:
    def __init__(self, name: str, description: str, parameters: dict, handler: ToolHandler):
        self.name = name
        self.description = description
        self.parameters = parameters
        self.handler = handler

    def to_openai_format(self) -> dict:
        return {
            "type": "function",
            "function": {
                "name": self.name,
                "description": self.description,
                "parameters": self.parameters,
            },
        }


class ToolRegistry:
    def __init__(self):
        self._tools: dict[str, Tool] = {}

    def register(self, tool: Tool):
        self._tools[tool.name] = tool

    def get_openai_tools(self) -> list[dict]:
        return [t.to_openai_format() for t in self._tools.values()]

    async def execute(self, name: str, args: dict) -> str:
        tool = self._tools.get(name)
        if not tool:
            return f"Error: tool '{name}' not found."
        return await tool.handler(**args)
