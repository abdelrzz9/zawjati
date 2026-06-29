"""API integration tests using TestClient with mock dependencies."""
import pytest
import os

os.environ["LLM_API_KEY"] = "test-key-for-testing"

from httpx import AsyncClient, ASGITransport
from app.main import app


@pytest.fixture
def client():
    transport = ASGITransport(app=app)
    return AsyncClient(transport=transport, base_url="http://test")


@pytest.mark.asyncio
async def test_root_endpoint(client):
    response = await client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "Zawjati" in data["app"]


@pytest.mark.asyncio
async def test_health_endpoint(client):
    response = await client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "alive"


@pytest.mark.asyncio
async def test_live_endpoint(client):
    response = await client.get("/live")
    assert response.status_code == 200
    assert response.json()["status"] == "alive"


@pytest.mark.asyncio
async def test_ready_endpoint(client):
    response = await client.get("/ready")
    assert response.status_code == 200
    assert response.json()["status"] == "ready"


@pytest.mark.asyncio
async def test_personalities_endpoint(client):
    response = await client.get("/api/personalities")
    assert response.status_code == 200
    data = response.json()
    assert "personalities" in data
    assert "wife" in data["personalities"]


@pytest.mark.asyncio
async def test_profile_get(client):
    response = await client.get("/api/profile/test_user")
    assert response.status_code == 200
    data = response.json()
    assert data["user_id"] == "test_user"
    assert data["nickname"] is None


@pytest.mark.asyncio
async def test_profile_update(client):
    response = await client.post(
        "/api/profile/test_user",
        json={"user_id": "test_user", "nickname": "habibi", "personality": "friend"},
    )
    assert response.status_code == 200

    response = await client.get("/api/profile/test_user")
    data = response.json()
    assert data["nickname"] == "habibi"
    assert data["personality"] == "friend"


@pytest.mark.asyncio
async def test_metrics_summary(client):
    response = await client.get("/api/metrics/summary")
    assert response.status_code == 200
    data = response.json()
    assert "total_requests" in data


@pytest.mark.asyncio
async def test_rate_limit_headers(client):
    # Request ID header should be set
    response = await client.get("/health")
    assert "X-Request-ID" in response.headers or "x-request-id" in response.headers


@pytest.mark.asyncio
async def test_chat_validation(client):
    """Test that empty messages are rejected."""
    response = await client.post(
        "/api/chat",
        json={"message": "", "user_id": "test"},
    )
    assert response.status_code in (400, 422)


@pytest.mark.asyncio
async def test_cors_headers(client):
    response = await client.options(
        "/health",
        headers={"Origin": "http://example.com", "Access-Control-Request-Method": "GET"},
    )
    assert "access-control-allow-origin" in response.headers
