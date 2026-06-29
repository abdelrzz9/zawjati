# Pydantic models for requests/responses
from pydantic import BaseModel
from typing import Optional


class ChatRequest(BaseModel):
    message: str
    user_id: str
    personality: Optional[str] = "default"


class ChatResponse(BaseModel):
    reply: str
    emotion: Optional[str] = None


class MemoryItem(BaseModel):
    key: str
    value: str
    user_id: str
