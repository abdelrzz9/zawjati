import pytest
from datetime import datetime, timedelta
from app.store.conversation import ConversationStore
from app.store.episodic import EpisodicMemory
from app.store.semantic import SemanticMemory
from app.store.profile import ProfileStore
from app.models import MemoryEntry


class TestConversationStore:
    def test_add_and_get_history(self):
        cs = ConversationStore()
        cs.add_turn("u1", "user", "hello")
        cs.add_turn("u1", "assistant", "hi")
        history = cs.get_history("u1")
        assert len(history) == 2
        assert history[0]["role"] == "user"
        assert history[0]["content"] == "hello"

    def test_history_limit(self):
        cs = ConversationStore()
        for i in range(100):
            cs.add_turn("u1", "user", f"msg {i}")
        history = cs.get_history("u1")
        assert len(history) <= 50

    def test_build_summary(self):
        cs = ConversationStore()
        cs.add_turn("u1", "user", "How are you?")
        cs.add_turn("u1", "assistant", "I'm great!")
        summary = cs.build_summary("u1")
        assert "How are you" in summary
        assert "I'm great" in summary

    def test_clear(self):
        cs = ConversationStore()
        cs.add_turn("u1", "user", "hello")
        cs.clear("u1")
        assert len(cs.get_history("u1")) == 0

    def test_total_turns(self):
        cs = ConversationStore()
        assert cs.total_turns("u1") == 0
        cs.add_turn("u1", "user", "hi")
        assert cs.total_turns("u1") == 1


class TestEpisodicMemory:
    @pytest.mark.asyncio
    async def test_add_and_query(self):
        em = EpisodicMemory()
        e1 = MemoryEntry(content="user visited paris", user_id="u1", category="event", importance=7)
        await em.add("u1", e1)

        results = await em.query("u1", "paris")
        assert len(results) == 1
        assert results[0].content == "user visited paris"

    @pytest.mark.asyncio
    async def test_query_relevance(self):
        em = EpisodicMemory()
        await em.add("u1", MemoryEntry(content="likes coffee", user_id="u1", importance=3))
        await em.add("u1", MemoryEntry(content="loves paris", user_id="u1", category="event", importance=8))

        results = await em.query("u1", "paris travel")
        assert len(results) >= 1
        assert any("paris" in r.content for r in results)

    @pytest.mark.asyncio
    async def test_get_by_category(self):
        em = EpisodicMemory()
        await em.add("u1", MemoryEntry(content="event1", user_id="u1", category="event"))
        await em.add("u1", MemoryEntry(content="fact1", user_id="u1", category="fact"))
        events = await em.get_by_category("u1", "event")
        assert len(events) == 1

    @pytest.mark.asyncio
    async def test_get_by_id(self):
        em = EpisodicMemory()
        e = MemoryEntry(content="test", user_id="u1")
        await em.add("u1", e)
        found = await em.get_by_id("u1", e.id)
        assert found is not None
        assert found.content == "test"

    @pytest.mark.asyncio
    async def test_update(self):
        em = EpisodicMemory()
        e = MemoryEntry(content="original", user_id="u1")
        await em.add("u1", e)
        e.content = "updated"
        await em.update("u1", e)
        found = await em.get_by_id("u1", e.id)
        assert found.content == "updated"

    @pytest.mark.asyncio
    async def test_delete(self):
        em = EpisodicMemory()
        e = MemoryEntry(content="delete me", user_id="u1")
        await em.add("u1", e)
        await em.delete("u1", e.id)
        assert await em.get_by_id("u1", e.id) is None


class TestSemanticMemory:
    @pytest.mark.asyncio
    async def test_deduplication(self):
        sm = SemanticMemory()
        await sm.add("u1", MemoryEntry(content="likes coffee", user_id="u1", importance=5))
        await sm.add("u1", MemoryEntry(content="likes coffee", user_id="u1", importance=8))
        all_mem = await sm.get_all("u1")
        assert len(all_mem) == 1
        assert all_mem[0].importance == 8

    @pytest.mark.asyncio
    async def test_query(self):
        sm = SemanticMemory()
        await sm.add("u1", MemoryEntry(content="user likes python programming", user_id="u1", importance=6))
        results = await sm.query("u1", "python")
        assert len(results) == 1

    @pytest.mark.asyncio
    async def test_get_all(self):
        sm = SemanticMemory()
        await sm.add("u1", MemoryEntry(content="a", user_id="u1"))
        await sm.add("u1", MemoryEntry(content="b", user_id="u1"))
        all_mem = await sm.get_all("u1")
        assert len(all_mem) == 2


class TestProfileStore:
    @pytest.mark.asyncio
    async def test_get_creates_default(self):
        ps = ProfileStore()
        profile = await ps.get("new_user")
        assert profile.user_id == "new_user"
        assert profile.nickname is None

    @pytest.mark.asyncio
    async def test_update(self):
        ps = ProfileStore()
        from app.models import UserProfile
        p = UserProfile(user_id="u1", nickname="habibi")
        await ps.update("u1", p)
        profile = await ps.get("u1")
        assert profile.nickname == "habibi"

    @pytest.mark.asyncio
    async def test_delete(self):
        ps = ProfileStore()
        await ps.get("u1")
        await ps.delete("u1")
        profile = await ps.get("u1")
        assert profile.user_id == "u1"  # creates fresh
