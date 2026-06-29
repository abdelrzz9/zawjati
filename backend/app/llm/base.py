from abc import ABC, abstractmethod
from typing import AsyncIterator, Optional, Callable
from ..models import LLMResponse, LLMUsage


class LLMProviderError(Exception):
    def __init__(self, message: str, code: str = "provider_error", status_code: int = 500):
        self.code = code
        self.status_code = status_code
        super().__init__(message)


class RateLimitError(LLMProviderError):
    def __init__(self, message: str = "Rate limit exceeded", retry_after: float = 60):
        self.retry_after = retry_after
        super().__init__(message, code="rate_limit", status_code=429)


class LLMProvider(ABC):
    model: str
    provider_name: str = "unknown"

    @abstractmethod
    async def chat(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> LLMResponse:
        ...

    @abstractmethod
    async def chat_stream(
        self,
        messages: list[dict],
        tools: Optional[list[dict]] = None,
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> AsyncIterator[str]:
        ...
        if False:
            yield

    def _build_usage(
        self,
        prompt_tokens: int = 0,
        completion_tokens: int = 0,
        cost_per_1k_prompt: float = 0.0,
        cost_per_1k_completion: float = 0.0,
    ) -> LLMUsage:
        cost = (prompt_tokens / 1000 * cost_per_1k_prompt) + (completion_tokens / 1000 * cost_per_1k_completion)
        return LLMUsage(
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=prompt_tokens + completion_tokens,
            cost=round(cost, 6),
            model=self.model,
            provider=self.provider_name,
        )


DEFAULT_RETRY_CODES = {"rate_limit", "server_error", "timeout", "service_unavailable"}


async def with_retry(
    fn: Callable,
    max_retries: int = 3,
    base_delay: float = 1.0,
    max_delay: float = 30.0,
    retryable_codes: set[str] | None = None,
) -> any:
    import asyncio
    import random

    retryable = retryable_codes or DEFAULT_RETRY_CODES
    last_error = None

    for attempt in range(max_retries + 1):
        try:
            return await fn()
        except RateLimitError as e:
            last_error = e
            if attempt >= max_retries:
                raise
            delay = min(e.retry_after, max_delay)
            await asyncio.sleep(delay + random.uniform(0, 0.5))
        except LLMProviderError as e:
            last_error = e
            if e.code not in retryable or attempt >= max_retries:
                raise
            delay = min(base_delay * (2 ** attempt) + random.uniform(0, 1), max_delay)
            await asyncio.sleep(delay)
        except Exception as e:
            raise LLMProviderError(str(e), code="unexpected_error") from e

    raise last_error  # pragma: no cover
