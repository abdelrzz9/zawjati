"""WebSocket and WebSocket manager tests."""
import json
import asyncio
import pytest
from unittest.mock import patch
from app.websocket_manager import WebSocketManager


class MockWebSocket:
    def __init__(self):
        self.sent_messages = []
        self.closed = False

    async def accept(self):
        pass

    async def receive_text(self):
        return '{"type": "ping"}'

    async def send_json(self, data: dict):
        self.sent_messages.append(data)

    async def close(self):
        self.closed = True


@pytest.mark.asyncio
async def test_ws_manager_connect():
    manager = WebSocketManager()
    mock_ws = MockWebSocket()

    session_id = await manager.connect(mock_ws, "user1")
    assert session_id is not None
    assert len(mock_ws.sent_messages) == 1
    assert mock_ws.sent_messages[0]["type"] == "connected"
    assert mock_ws.sent_messages[0]["session_id"] == session_id


@pytest.mark.asyncio
async def test_ws_manager_disconnect():
    manager = WebSocketManager()
    mock_ws = MockWebSocket()

    session_id = await manager.connect(mock_ws, "user1")
    await manager.disconnect("user1", session_id)

    assert manager.get_active_connections("user1") == 0
    assert mock_ws.closed


@pytest.mark.asyncio
async def test_ws_manager_get_stats():
    manager = WebSocketManager()
    mock_ws = MockWebSocket()

    await manager.connect(mock_ws, "user1")
    await manager.connect(MockWebSocket(), "user1")
    await manager.connect(MockWebSocket(), "user2")

    stats = manager.get_stats()
    assert stats["total_connections"] == 3
    assert stats["active_users"] == 2


@pytest.mark.asyncio
async def test_ws_manager_broadcast():
    manager = WebSocketManager()
    ws1 = MockWebSocket()
    ws2 = MockWebSocket()

    await manager.connect(ws1, "user1")
    await manager.connect(ws2, "user1")

    await manager.broadcast("user1", {"type": "test", "data": "hello"})

    assert len(ws1.sent_messages) == 2
    assert ws1.sent_messages[-1]["type"] == "test"
    assert ws2.sent_messages[-1]["type"] == "test"


@pytest.mark.asyncio
async def test_ws_heartbeat_timeout():
    manager = WebSocketManager()
    mock_ws = MockWebSocket()
    session_id = await manager.connect(mock_ws, "user1")

    conn = manager._connections["user1"][session_id]
    conn.last_heartbeat = 0

    with patch.object(manager, "_heartbeat_interval", 0.1):
        with patch.object(manager, "_ping_timeout", 0.05):
            loop_task = asyncio.create_task(
                manager._heartbeat_loop("user1", session_id)
            )
            await asyncio.sleep(0.3)
            loop_task.cancel()
            try:
                await loop_task
            except (asyncio.CancelledError, RuntimeError):
                pass

    assert mock_ws.closed


@pytest.mark.asyncio
async def test_ws_duplicate_message_prevention():
    manager = WebSocketManager()
    mock_ws = MockWebSocket()
    session_id = await manager.connect(mock_ws, "user1")

    async def mock_process(ws, msg, uid, sid):
        pass

    await manager._process_message(
        "user1", session_id,
        json.dumps({"type": "message", "id": "dup-1", "content": "hello"}),
        mock_process,
    )

    await manager._process_message(
        "user1", session_id,
        json.dumps({"type": "message", "id": "dup-1", "content": "hello"}),
        mock_process,
    )

    last_msg = mock_ws.sent_messages[-1]
    assert last_msg["type"] == "duplicate"
