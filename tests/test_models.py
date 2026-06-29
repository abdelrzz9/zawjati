from app.models import (
    UserProfile, ChatRequest, ChatResponse, MemoryEntry,
    ConversationTurn, LLMResponse, LLMUsage, ErrorDetail, ErrorResponse,
)


def test_user_profile_defaults():
    p = UserProfile(user_id="test")
    assert p.user_id == "test"
    assert p.nickname is None
    assert p.relationship_type.value == "companion"
    assert p.personality == "wife"
    assert p.language == "en"


def test_user_profile_custom():
    p = UserProfile(user_id="test", nickname="habibi", personality="friend")
    assert p.nickname == "habibi"
    assert p.personality == "friend"


def test_chat_request_validation():
    req = ChatRequest(message="hello", user_id="u1")
    assert req.message == "hello"
    assert req.stream is False


def test_memory_entry_defaults():
    m = MemoryEntry(content="likes coffee", user_id="u1")
    assert m.id is not None
    assert len(m.id) == 12
    assert m.importance == 5
    assert m.confidence == 0.7
    assert m.category == "fact"
    assert m.access_count == 0


def test_memory_entry_custom():
    m = MemoryEntry(
        content="wants to learn piano",
        user_id="u1",
        category="goal",
        importance=8,
        confidence=0.9,
    )
    assert m.category == "goal"
    assert m.importance == 8
    assert m.confidence == 0.9


def test_conversation_turn():
    t = ConversationTurn(role="user", content="hello")
    assert t.role == "user"
    assert t.content == "hello"
    assert t.timestamp is not None


def test_llm_usage():
    u = LLMUsage(prompt_tokens=100, completion_tokens=50)
    assert u.total_tokens == 150
    assert u.cost == 0.0
    assert u.model == ""


def test_llm_response():
    r = LLMResponse(content="hello", tool_calls=[{"name": "test"}])
    assert r.content == "hello"
    assert len(r.tool_calls) == 1


def test_error_detail():
    e = ErrorDetail(code="test_error", message="Something broke", request_id="r1")
    assert e.code == "test_error"
    assert e.request_id == "r1"


def test_error_response():
    detail = ErrorDetail(code="err", message="fail")
    resp = ErrorResponse(error=detail)
    assert resp.error.code == "err"
