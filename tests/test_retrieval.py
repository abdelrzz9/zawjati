import pytest
from app.core.retrieval import RetrievalPipeline
from app.store.conversation import ConversationStore
from app.store.episodic import EpisodicMemory
from app.store.semantic import SemanticMemory
from app.store.profile import ProfileStore
from app.models import MemoryEntry


@pytest.mark.asyncio
async def test_retrieve_returns_all_sections():
    cs = ConversationStore()
    cs.add_turn("u1", "user", "hello")
    em = EpisodicMemory()
    sm = SemanticMemory()
    ps = ProfileStore()

    await em.add("u1", MemoryEntry(content="went to paris", user_id="u1", category="event", importance=7))
    await sm.add("u1", MemoryEntry(content="likes coffee", user_id="u1", importance=5))

    rp = RetrievalPipeline(cs, em, sm, ps)
    result = await rp.retrieve("u1", "paris coffee")

    assert "history" in result
    assert "episodic" in result
    assert "semantic" in result
    assert "profile" in result
    assert "timing_ms" in result
    assert len(result["history"]) > 0


@pytest.mark.asyncio
async def test_format_memories():
    entries = [
        MemoryEntry(content="test entry", user_id="u1", importance=9),
        MemoryEntry(content="normal entry", user_id="u1", importance=5, confidence=0.95),
    ]
    formatted = RetrievalPipeline.format_memories(entries)
    assert "[IMPORTANT]" in formatted
    assert "[HIGH CONFIDENCE]" in formatted


@pytest.mark.asyncio
async def test_format_empty():
    assert RetrievalPipeline.format_memories([]) == ""


@pytest.mark.asyncio
async def test_retrieve_profile():
    cs = ConversationStore()
    em = EpisodicMemory()
    sm = SemanticMemory()
    ps = ProfileStore()

    from app.models import UserProfile
    await ps.update("u1", UserProfile(user_id="u1", nickname="buddy"))

    rp = RetrievalPipeline(cs, em, sm, ps)
    result = await rp.retrieve("u1", "hello")
    assert result["profile"].nickname == "buddy"
