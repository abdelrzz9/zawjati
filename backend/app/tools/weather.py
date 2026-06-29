from .base import BaseTool


class WeatherTool(BaseTool):
    name = "get_weather"
    description = "Get current weather for a location"
    parameters = {
        "type": "object",
        "properties": {
            "location": {
                "type": "string",
                "description": "City or location name",
            }
        },
        "required": ["location"],
    }

    async def execute(self, location: str) -> str:
        return f"Weather data for {location} is not yet implemented. Add an API key to enable this."
