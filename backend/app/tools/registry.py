from typing import Optional
from .base import BaseTool


class ToolRegistry:
    def __init__(self):
        self._tools: dict[str, BaseTool] = {}

    def register(self, tool: BaseTool):
        self._tools[tool.name] = tool

    def get(self, name: str) -> Optional[BaseTool]:
        return self._tools.get(name)

    def get_all(self) -> list[BaseTool]:
        return list(self._tools.values())

    def get_openai_tools(self) -> list[dict]:
        return [t.to_openai_format() for t in self._tools.values()]

    async def execute(self, name: str, args: dict) -> str:
        tool = self.get(name)
        if not tool:
            return f"Error: tool '{name}' not found."
        return await tool.execute(**args)

    def register_all(self, *tools: BaseTool):
        for t in tools:
            self.register(t)
