"""Mock LLM provider for testing + provider tests."""
import pytest
from typing import AsyncIterator, Optional
from app.llm.base import LLMProvider, LLMProviderError, RateLimitError, with_retry
from app.models import LLMResponse


class MockLLMProvider(LLMProvider):
    provider_name = "mock"

    def __init__(self, responses: list[str] | None = None):
        self.responses = responses or ["mock response"]
        self.call_count = 0
        self.model = "mock-model"

    async def chat(self, messages, tools=None, temperature=0.7, max_tokens=2048):
        idx = min(self.call_count, len(self.responses) - 1)
        self.call_count += 1
        return LLMResponse(
            content=self.responses[idx],
            usage=self._build_usage(prompt_tokens=10, completion_tokens=5),
        )

    async def chat_stream(self, messages, tools=None, temperature=0.7, max_tokens=2048):
        for char in "mock response":
            yield char


class FailingProvider(LLMProvider):
    provider_name = "failing"

    def __init__(self):
        self.model = "fail-model"

    async def chat(self, messages, tools=None, temperature=0.7, max_tokens=2048):
        raise RateLimitError("Too fast", retry_after=0.01)

    async def chat_stream(self, messages, tools=None, temperature=0.7, max_tokens=2048):
        raise RateLimitError("Too fast")
        yield  # pragma: no cover


class TestMockLLMProvider:
    @pytest.mark.asyncio
    async def test_basic_chat(self):
        llm = MockLLMProvider()
        response = await llm.chat([{"role": "user", "content": "hello"}])
        assert response.content == "mock response"
        assert response.usage.prompt_tokens == 10

    @pytest.mark.asyncio
    async def test_stream(self):
        llm = MockLLMProvider()
        chunks = []
        async for c in llm.chat_stream([]):
            chunks.append(c)
        assert "".join(chunks) == "mock response"

    @pytest.mark.asyncio
    async def test_multiple_responses(self):
        llm = MockLLMProvider(["first", "second"])
        r1 = await llm.chat([])
        r2 = await llm.chat([])
        assert r1.content == "first"
        assert r2.content == "second"


class TestRetryLogic:
    @pytest.mark.asyncio
    async def test_retry_success(self):
        """Should succeed after retries if the provider eventually works."""
        call_count = 0

        async def flaky_fn():
            nonlocal call_count
            call_count += 1
            if call_count < 3:
                raise RateLimitError("slow down", retry_after=0.01)
            return "success"

        result = await with_retry(flaky_fn, max_retries=3, base_delay=0.01)
        assert result == "success"
        assert call_count == 3

    @pytest.mark.asyncio
    async def test_retry_fails_eventually(self):
        async def always_fails():
            raise RateLimitError("always", retry_after=0.01)

        with pytest.raises(LLMProviderError):
            await with_retry(always_fails, max_retries=2, base_delay=0.01)

    @pytest.mark.asyncio
    async def test_non_retryable_error(self):
        async def fails_hard():
            raise LLMProviderError("bad request", code="bad_request")

        with pytest.raises(LLMProviderError, match="bad request"):
            await with_retry(fails_hard, max_retries=3, base_delay=0.01)

    @pytest.mark.asyncio
    async def test_unexpected_exception_wrapped(self):
        async def crash():
            raise ValueError("something unexpected")

        with pytest.raises(LLMProviderError):
            await with_retry(crash, max_retries=2, base_delay=0.01)
