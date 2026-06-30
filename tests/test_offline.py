"""Offline behavior tests."""
import pytest
from app.store.conversation import ConversationStore
from app.store.semantic import SemanticMemory
from app.store.episodic import EpisodicMemory
from app.models import MemoryEntry, ConversationTurn


@pytest.mark.asyncio
async def test_conversation_store_offline_capable():
    store = ConversationStore()
    store.add_turn("user1", "user", "Hello")
    store.add_turn("user1", "assistant", "Hi there!")

    history = store.get_history("user1")
    assert len(history) == 2
    assert history[0]["role"] == "user"
    assert history[1]["role"] == "assistant"


@pytest.mark.asyncio
async def test_semantic_memory_offline_capable():
    store = SemanticMemory()
    entry = MemoryEntry(content="Test memory", user_id="offline_user", importance=5)
    await store.add("offline_user", entry)

    results = await store.query("offline_user", "test")
    assert len(results) > 0
    assert results[0].content == "Test memory"


@pytest.mark.asyncio
async def test_episodic_memory_offline_capable():
    store = EpisodicMemory()
    entry = MemoryEntry(
        content="Important event",
        user_id="offline_user",
        category="event",
        importance=8,
    )
    await store.add("offline_user", entry)

    results = await store.query("offline_user", "event")
    assert len(results) > 0
    assert results[0].importance == 8


@pytest.mark.asyncio
async def test_profile_store_offline():
    from app.store.profile import ProfileStore
    from app.models import UserProfile

    store = ProfileStore()
    profile = UserProfile(user_id="offline_user", nickname="Test")
    await store.update("offline_user", profile)

    retrieved = await store.get("offline_user")
    assert retrieved.nickname == "Test"


@pytest.mark.asyncio
async def test_conversation_trimming():
    store = ConversationStore()
    for i in range(100):
        store.add_turn("heavy_user", "user", f"Message {i}")
        store.add_turn("heavy_user", "assistant", f"Response {i}")

    history = store.get_history("heavy_user")
    assert len(history) <= 60


@pytest.mark.asyncio
async def test_conversation_summary():
    store = ConversationStore()
    store.add_turn("summary_user", "user", "Hello")
    store.add_turn("summary_user", "assistant", "Hi!")

    summary = store.build_summary("summary_user")
    assert "Hello" in summary or "Hello" in summary
