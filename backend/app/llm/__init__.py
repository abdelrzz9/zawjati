from .base import LLMProvider, LLMProviderError, RateLimitError
from .openai import OpenAIProvider
from .ollama import OllamaProvider
from ..config import settings


def create_llm_provider() -> LLMProvider:
    match settings.llm_provider:
        case "openai":
            return OpenAIProvider(
                api_key=settings.llm_api_key,
                model=settings.llm_model,
            )
        case "ollama":
            return OllamaProvider(
                base_url=settings.ollama_base_url,
                model=settings.ollama_model,
            )
        case "openrouter":
            from .openrouter import OpenRouterProvider
            return OpenRouterProvider(
                api_key=settings.openrouter_api_key or settings.llm_api_key,
                model=settings.llm_model,
            )
        case "anthropic":
            from .anthropic import AnthropicProvider
            return AnthropicProvider(
                api_key=settings.anthropic_api_key or "",
                model=settings.llm_model,
            )
        case "groq":
            from .groq import GroqProvider
            return GroqProvider(
                api_key=settings.groq_api_key or "",
                model=settings.llm_model,
            )
        case "gemini":
            from .gemini import GeminiProvider
            return GeminiProvider(
                api_key=settings.gemini_api_key or "",
                model=settings.llm_model,
            )
        case _:
            raise ValueError(f"Unsupported LLM provider: {settings.llm_provider}")
