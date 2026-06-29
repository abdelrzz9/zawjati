from abc import ABC, abstractmethod
from openai import AsyncOpenAI
from .config import settings


class LLMClient(ABC):
    @abstractmethod
    async def chat(self, messages: list, tools: list | None = None) -> str:
        ...


class OpenAIClient(LLMClient):
    def __init__(self):
        self.client = AsyncOpenAI(api_key=settings.llm_api_key)
        self.model = settings.llm_model

    async def chat(self, messages: list, tools: list | None = None) -> str:
        kwargs = dict(model=self.model, messages=messages)
        if tools:
            kwargs["tools"] = tools
        response = await self.client.chat.completions.create(**kwargs)
        return response.choices[0].message.content


def create_llm_client() -> LLMClient:
    if settings.llm_provider == "openai":
        return OpenAIClient()
    raise ValueError(f"Unsupported LLM provider: {settings.llm_provider}")
