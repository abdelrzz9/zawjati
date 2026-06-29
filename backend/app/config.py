from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    llm_provider: str = "openai"
    llm_api_key: str = ""
    llm_model: str = "gpt-4o-mini"
    database_url: str = "sqlite:///data/zawjati.db"
    max_history: int = 50

    class Config:
        env_file = ".env"


settings = Settings()
