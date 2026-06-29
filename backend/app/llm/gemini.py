from typing import AsyncIterator, Optional
from .base import LLMProvider
from ..models import LLMResponse


class GeminiProvider(LLMProvider):
    def __init__(self, api_key: str, model: str = "gemini-1.5-flash"):
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
        msg = "Gemini provider requires the `google-genai` SDK. Install with: pip install google-genai"
        raise NotImplementedError(msg)

    async def chat_stream(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> AsyncIterator[str]:
        raise NotImplementedError("Gemini streaming not yet implemented")
        if False:
            yield  # pragma: no cover
