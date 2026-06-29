from abc import ABC, abstractmethod
from typing import Any
import re


class BaseTool(ABC):
    name: str
    description: str
    parameters: dict

    @abstractmethod
    async def execute(self, **kwargs) -> str:
        ...

    def to_openai_format(self) -> dict:
        return {
            "type": "function",
            "function": {
                "name": self.name,
                "description": self.description,
                "parameters": self.parameters,
            },
        }

    def sanitize_output(self, output: str) -> str:
        if not output:
            return ""
        output = re.sub(r"[<>]", "", output)
        output = re.sub(r"\s+", " ", output).strip()
        return output[:1000]
