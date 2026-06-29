from pydantic import BaseModel, Field
from typing import Optional, Literal, Any
from datetime import datetime
from enum import Enum
from uuid import uuid4


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
    message: str = Field(..., min_length=1, max_length=10000)
    user_id: str = Field(..., min_length=1, max_length=256)
    personality: Optional[str] = None
    stream: bool = False


class ChatResponse(BaseModel):
    reply: str
    request_id: str = ""
    emotion: Optional[str] = None
    model: Optional[str] = None
    provider: Optional[str] = None
    latency_ms: Optional[float] = None
    prompt_tokens: Optional[int] = None
    completion_tokens: Optional[int] = None
    total_tokens: Optional[int] = None
    cost: Optional[float] = None


class ChatEvent(BaseModel):
    event: Literal["start", "token", "done", "error", "tool_call", "metadata"]
    data: Any


class ErrorDetail(BaseModel):
    code: str
    message: str
    request_id: str = ""
    details: Optional[dict] = None


class ErrorResponse(BaseModel):
    error: ErrorDetail


memory_categories = Literal[
    "preference", "fact", "goal", "event", "concept",
    "relationship", "achievement", "routine", "opinion",
]


class MemoryEntry(BaseModel):
    id: str = Field(default_factory=lambda: uuid4().hex[:12])
    content: str
    user_id: str
    category: memory_categories = "fact"
    importance: int = Field(default=5, ge=1, le=10)
    confidence: float = Field(default=0.7, ge=0.0, le=1.0)
    timestamp: datetime = Field(default_factory=datetime.now)
    last_accessed: datetime = Field(default_factory=datetime.now)
    access_count: int = 0
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
    provider: str = ""

    def model_post_init(self, __context):
        if not self.total_tokens and (self.prompt_tokens or self.completion_tokens):
            self.total_tokens = self.prompt_tokens + self.completion_tokens


class LLMResponse(BaseModel):
    content: str
    usage: LLMUsage = Field(default_factory=LLMUsage)
    tool_calls: list[dict] = Field(default_factory=list)
