from pydantic import BaseModel
from typing import Optional, Literal
from datetime import datetime


class UserProfile(BaseModel):
    user_id: str
    nickname: Optional[str] = None
    relationship_type: Literal["companion", "friend", "partner", "custom"] = "companion"
    personality_preference: str = "default"
    language: str = "en"


class ChatRequest(BaseModel):
    message: str
    user_id: str
    personality: Optional[str] = None


class ChatResponse(BaseModel):
    reply: str
    emotion: Optional[str] = None


class ConversationTurn(BaseModel):
    role: Literal["user", "assistant", "system"]
    content: str
    timestamp: datetime = datetime.now()


class MemoryEntry(BaseModel):
    key: str
    value: str
    user_id: str
    category: Optional[str] = None
    importance: int = 1
    timestamp: datetime = datetime.now()
