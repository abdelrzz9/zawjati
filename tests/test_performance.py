"""Performance and stress tests for the Zawjati API."""
import time
import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app


@pytest.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


@pytest.mark.asyncio
async def test_health_response_time(client):
    start = time.perf_counter()
    for _ in range(10):
        await client.get("/health")
    elapsed = (time.perf_counter() - start) * 1000
    avg = elapsed / 10
    assert avg < 100, f"Average health check response time too high: {avg:.1f}ms"


@pytest.mark.asyncio
async def test_concurrent_health_checks(client):
    import asyncio
    start = time.perf_counter()
    tasks = [client.get("/health") for _ in range(20)]
    responses = await asyncio.gather(*tasks)
    elapsed = (time.perf_counter() - start) * 1000
    assert elapsed < 2000, f"20 concurrent health checks too slow: {elapsed:.1f}ms"
    for r in responses:
        assert r.status_code == 200


@pytest.mark.asyncio
async def test_large_payload_rejection(client):
    large_message = "x" * 10001
    response = await client.post(
        "/api/chat",
        json={"message": large_message, "user_id": "test"},
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_prompt_builder_performance():
    from app.core.prompt_builder import PromptBuilder
    from app.core.personality import PersonalityEngine
    builder = PromptBuilder()
    personality_content = PersonalityEngine().load_personality("wife")

    start = time.perf_counter()
    for _ in range(100):
        prompt = builder.build(
            personality="wife",
            personality_content=personality_content,
            nickname="Test",
            relationship_type="partner",
        )
    elapsed = (time.perf_counter() - start) * 1000
    avg = elapsed / 100
    assert avg < 10, f"Average prompt build time too high: {avg:.2f}ms"


@pytest.mark.asyncio
async def test_memory_store_performance():
    from app.store.semantic import SemanticMemory
    from app.models import MemoryEntry
    import asyncio

    store = SemanticMemory()
    entries = [
        MemoryEntry(content=f"Memory {i}", user_id="perf_test", importance=5)
        for i in range(100)
    ]

    start = time.perf_counter()
    for entry in entries:
        await store.add("perf_test", entry)
    add_elapsed = (time.perf_counter() - start) * 1000

    assert add_elapsed < 500, f"Adding 100 memories too slow: {add_elapsed:.1f}ms"

    start = time.perf_counter()
    for _ in range(10):
        await store.query("perf_test", "memory")
    query_elapsed = (time.perf_counter() - start) * 1000
    assert query_elapsed < 100, f"10 memory queries too slow: {query_elapsed:.1f}ms"
