from pydantic import BaseModel, Field
from typing import Optional, Literal, Any
from datetime import datetime
from enum import Enum


class RelationshipType(str, Enum):
    companion = "companion"
    friend = "friend"
    partner = "partner"
    custom = "custom"


class UserProfile(BaseModel):
    user_id: str
    nickname: Optional[str] = None
    relationship_type: RelationshipType = RelationshipType.companion
    personality: str = "wife"
    language: str = "en"


class ChatRequest(BaseModel):
    message: str
    user_id: str
    personality: Optional[str] = None
    stream: bool = False


class ChatResponse(BaseModel):
    reply: str
    emotion: Optional[str] = None
    model: Optional[str] = None
    latency_ms: Optional[float] = None
    tokens_prompt: Optional[int] = None
    tokens_completion: Optional[int] = None
    cost: Optional[float] = None


class ChatEvent(BaseModel):
    event: Literal["token", "done", "error", "tool_call"]
    data: Any


class MemoryEntry(BaseModel):
    content: str
    user_id: str
    category: Literal["preference", "fact", "goal", "event", "concept"] = "fact"
    importance: int = Field(default=1, ge=1, le=10)
    timestamp: datetime = Field(default_factory=datetime.now)
    metadata: dict[str, Any] = Field(default_factory=dict)


class MemoryQuery(BaseModel):
    user_id: str
    query: str
    category: Optional[str] = None
    limit: int = 10
    min_importance: int = 1


class ConversationTurn(BaseModel):
    role: Literal["user", "assistant", "system"]
    content: str
    timestamp: datetime = Field(default_factory=datetime.now)
    metadata: dict[str, Any] = Field(default_factory=dict)


class LLMUsage(BaseModel):
    prompt_tokens: int = 0
    completion_tokens: int = 0
    total_tokens: int = 0
    cost: float = 0.0
    model: str = ""


class LLMResponse(BaseModel):
    content: str
    usage: LLMUsage = Field(default_factory=LLMUsage)
    tool_calls: list[dict] = Field(default_factory=list)
