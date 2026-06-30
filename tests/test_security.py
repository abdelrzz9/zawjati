"""Security tests for the Zawjati API."""
import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app


@pytest.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


@pytest.mark.asyncio
async def test_security_headers(client):
    response = await client.get("/health")
    assert response.headers.get("x-content-type-options") == "nosniff"
    assert response.headers.get("x-frame-options") == "DENY"
    assert "strict-transport-security" in response.headers


@pytest.mark.asyncio
async def test_csp_header(client):
    response = await client.get("/health")
    csp = response.headers.get("content-security-policy", "")
    assert "default-src 'self'" in csp
    assert "frame-ancestors 'none'" in csp


@pytest.mark.asyncio
async def test_cors_validation(client):
    response = await client.options(
        "/health",
        headers={
            "Origin": "https://evil.com",
            "Access-Control-Request-Method": "GET",
        },
    )
    assert "access-control-allow-origin" in response.headers


@pytest.mark.asyncio
async def test_input_validation():
    from app.models import ChatRequest
    from pydantic import ValidationError
    import pytest

    with pytest.raises(ValidationError):
        ChatRequest(message="", user_id="test")

    with pytest.raises(ValidationError):
        ChatRequest(message="x" * 10001, user_id="test")

    with pytest.raises(ValidationError):
        ChatRequest(message="hi", user_id="")

    with pytest.raises(ValidationError):
        ChatRequest(message="hi", user_id="x" * 257)


@pytest.mark.asyncio
async def test_request_id_tracing(client):
    response = await client.get("/ready", headers={"X-Request-ID": "test-req-123"})
    assert response.headers.get("x-request-id") == "test-req-123"


@pytest.mark.asyncio
async def test_calculator_injection_protection():
    from app.tools.calculator import CalculatorTool
    tool = CalculatorTool()

    result = await tool.execute(expression="__import__('os').system('ls')")
    assert "error" in result.lower() or "invalid" in result.lower()

    result = await tool.execute(expression="1+1")
    assert result == "2"


@pytest.mark.asyncio
async def test_tool_output_sanitization():
    from app.tools.calculator import CalculatorTool
    tool = CalculatorTool()
    dirty = "<script>alert('xss')</script>Hello"
    clean = tool.sanitize_output(dirty)
    assert "<script>" not in clean
    assert "Hello" in clean


@pytest.mark.asyncio
async def test_memory_entry_importance_bounds():
    from app.models import MemoryEntry

    entry = MemoryEntry(content="test", user_id="u1", importance=5)
    assert entry.importance == 5

    entry = MemoryEntry(content="test", user_id="u1", importance=1)
    assert entry.importance == 1

    entry = MemoryEntry(content="test", user_id="u1", importance=10)
    assert entry.importance == 10
