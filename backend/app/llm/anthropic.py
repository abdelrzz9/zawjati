from typing import AsyncIterator, Optional
from .base import LLMProvider
from ..models import LLMResponse


class AnthropicProvider(LLMProvider):
    def __init__(self, api_key: str, model: str = "claude-3-haiku-20240307"):
        self.api_key = api_key
        self.model = model
        self._available = False

    async def chat(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> LLMResponse:
        msg = "Anthropic provider requires the `anthropic` SDK. Install with: pip install anthropic"
        raise NotImplementedError(msg)

    async def chat_stream(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> AsyncIterator[str]:
        raise NotImplementedError("Anthropic streaming not yet implemented")
        if False:
            yield  # pragma: no cover
