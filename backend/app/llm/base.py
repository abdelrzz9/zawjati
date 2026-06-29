from abc import ABC, abstractmethod
from typing import AsyncIterator, Optional
from ..models import LLMResponse, LLMUsage


class LLMProvider(ABC):
    model: str

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
        yield  # marker for generator

    def _build_usage(self, prompt_tokens: int, completion_tokens: int, cost_per_1k_prompt: float = 0.0, cost_per_1k_completion: float = 0.0) -> LLMUsage:
        cost = (prompt_tokens / 1000 * cost_per_1k_prompt) + (completion_tokens / 1000 * cost_per_1k_completion)
        return LLMUsage(
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=prompt_tokens + completion_tokens,
            cost=round(cost, 6),
            model=self.model,
        )
