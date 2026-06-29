from .base import BaseTool


class ImageGenTool(BaseTool):
    name = "generate_image"
    description = "Generate an image from a text description"
    parameters = {
        "type": "object",
        "properties": {
            "prompt": {
                "type": "string",
                "description": "Image description",
            },
            "size": {
                "type": "string",
                "enum": ["256x256", "512x512", "1024x1024"],
                "description": "Image size",
            },
        },
        "required": ["prompt"],
    }

    async def execute(self, prompt: str, size: str = "1024x1024") -> str:
        return f"Image generation for '{prompt}' is not yet implemented. Add an API key to enable this."
