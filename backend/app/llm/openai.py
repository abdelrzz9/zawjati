from typing import AsyncIterator, Optional
from openai import AsyncOpenAI, APIError, RateLimitError as OpenAIRateLimit
from .base import LLMProvider, LLMProviderError, RateLimitError, with_retry
from ..models import LLMResponse

COST_PER_1K = {
    "gpt-4o": (0.005, 0.015),
    "gpt-4o-mini": (0.00015, 0.0006),
    "gpt-4-turbo": (0.01, 0.03),
    "gpt-3.5-turbo": (0.0005, 0.0015),
}


class OpenAIProvider(LLMProvider):
    provider_name = "openai"

    def __init__(self, api_key: str, model: str = "gpt-4o-mini"):
        self.client = AsyncOpenAI(api_key=api_key)
        self.model = model

    def _get_costs(self) -> tuple[float, float]:
        return COST_PER_1K.get(self.model, (0.0, 0.0))

    def _handle_error(self, e: Exception) -> LLMProviderError:
        if isinstance(e, OpenAIRateLimit):
            return RateLimitError(retry_after=60)
        if isinstance(e, APIError):
            code = "server_error" if e.status_code >= 500 else "provider_error"
            return LLMProviderError(str(e), code=code, status_code=e.status_code or 500)
        return LLMProviderError(str(e), code="provider_error")

    async def chat(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> LLMResponse:
        async def _do_chat():
            kwargs = dict(
                model=self.model,
                messages=messages,
                temperature=temperature,
                max_tokens=max_tokens,
            )
            if tools:
                kwargs["tools"] = tools
            return await self.client.chat.completions.create(**kwargs)

        try:
            response = await with_retry(_do_chat)
        except Exception as e:
            raise self._handle_error(e)

        choice = response.choices[0]
        content = choice.message.content or ""
        prompt_tokens = response.usage.prompt_tokens if response.usage else 0
        completion_tokens = response.usage.completion_tokens if response.usage else 0
        cost_p, cost_c = self._get_costs()

        return LLMResponse(
            content=content,
            usage=self._build_usage(prompt_tokens, completion_tokens, cost_p, cost_c),
            tool_calls=[
                {"name": tc.function.name, "arguments": tc.function.arguments}
                for tc in (choice.message.tool_calls or [])
            ],
        )

    async def chat_stream(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> AsyncIterator[str]:
        kwargs = dict(
            model=self.model,
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
            stream=True,
        )
        if tools:
            kwargs["tools"] = tools

        try:
            stream = await self.client.chat.completions.create(**kwargs)
            async for chunk in stream:
                delta = chunk.choices[0].delta if chunk.choices else None
                if delta and delta.content:
                    yield delta.content
        except Exception as e:
            raise self._handle_error(e)
