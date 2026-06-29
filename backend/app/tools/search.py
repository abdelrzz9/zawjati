from .base import BaseTool


class WebSearchTool(BaseTool):
    name = "web_search"
    description = "Search the web for information"
    parameters = {
        "type": "object",
        "properties": {
            "query": {
                "type": "string",
                "description": "Search query",
            },
        },
        "required": ["query"],
    }

    async def execute(self, query: str) -> str:
        return f"Web search for '{query}' is not yet implemented. Add a search API key to enable this."
