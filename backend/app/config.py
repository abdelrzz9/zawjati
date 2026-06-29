from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    # LLM
    llm_provider: str = "openai"
    llm_api_key: str = ""
    llm_model: str = "gpt-4o-mini"
    llm_temperature: float = 0.7
    llm_max_tokens: int = 2048

    # Provider-specific API keys
    anthropic_api_key: Optional[str] = None
    gemini_api_key: Optional[str] = None
    openrouter_api_key: Optional[str] = None
    groq_api_key: Optional[str] = None

    # Local models
    ollama_base_url: str = "http://localhost:11434"
    ollama_model: str = "llama3"

    # Storage
    database_url: str = "sqlite:///data/zawjati.db"
    redis_url: Optional[str] = None
    memory_provider: str = "memory"  # memory, redis, sqlite

    # Context
    max_context_tokens: int = 8000
    max_history_messages: int = 50
    max_history_characters: int = 20000

    # Features
    streaming_enabled: bool = True
    enable_tool_calling: bool = True
    enable_memory: bool = True

    # Security
    rate_limit_per_minute: int = 60
    cors_origins: str = "*"  # comma-separated
    request_id_header: str = "X-Request-ID"

    # Observability
    log_level: str = "INFO"
    log_format: str = "json"  # json or text
    metrics_enabled: bool = True

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
