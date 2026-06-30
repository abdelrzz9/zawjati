import asyncio
import json
import time
import uuid
from typing import Optional, Set, Dict, Any
from collections import defaultdict
from fastapi import WebSocket, WebSocketDisconnect
from app.config import settings
from app.observability.logger import ObservabilityLogger

logger = ObservabilityLogger("zawjati.ws")


class WebSocketConnection:
    def __init__(self, websocket: WebSocket, user_id: str, session_id: str):
        self.websocket = websocket
        self.user_id = user_id
        self.session_id = session_id
        self.connected_at = time.time()
        self.last_heartbeat = time.time()
        self.message_ids: Set[str] = set()
        self.pending_messages: list = []
        self.subscribed_topics: Set[str] = set()


class WebSocketManager:
    def __init__(self):
        self._connections: Dict[str, Dict[str, WebSocketConnection]] = defaultdict(dict)
        self._sessions: Dict[str, str] = {}
        self._heartbeat_interval = 25
        self._ping_timeout = 10

    async def connect(self, websocket: WebSocket, user_id: str) -> str:
        await websocket.accept()
        session_id = uuid.uuid4().hex[:16]
        conn = WebSocketConnection(websocket, user_id, session_id)
        self._connections[user_id][session_id] = conn
        self._sessions[session_id] = user_id

        await self._send(websocket, {
            "type": "connected",
            "session_id": session_id,
            "heartbeat_interval": self._heartbeat_interval,
        })

        logger.info("WebSocket connected", user_id=user_id, session_id=session_id)
        return session_id

    async def disconnect(self, user_id: str, session_id: str):
        if session_id in self._connections.get(user_id, {}):
            conn = self._connections[user_id].pop(session_id)
            try:
                await conn.websocket.close()
            except Exception:
                pass
            self._sessions.pop(session_id, None)

            if not self._connections[user_id]:
                del self._connections[user_id]

            logger.info("WebSocket disconnected", user_id=user_id, session_id=session_id)

    async def handle_connection(
        self,
        websocket: WebSocket,
        user_id: str,
        process_fn,
    ):
        session_id = await self.connect(websocket, user_id)
        heartbeat_task = asyncio.create_task(
            self._heartbeat_loop(user_id, session_id)
        )

        try:
            while True:
                data = await websocket.receive_text()
                await self._process_message(user_id, session_id, data, process_fn)
        except WebSocketDisconnect:
            pass
        except Exception as e:
            logger.error("WebSocket error", user_id=user_id, session_id=session_id, error=str(e))
        finally:
            heartbeat_task.cancel()
            await self.disconnect(user_id, session_id)

    async def _process_message(
        self,
        user_id: str,
        session_id: str,
        data: str,
        process_fn,
    ):
        conn = self._connections.get(user_id, {}).get(session_id)
        if not conn:
            return

        try:
            msg = json.loads(data)
        except json.JSONDecodeError:
            await self._send_error(conn.websocket, "invalid_json", "Invalid JSON")
            return

        msg_type = msg.get("type", "message")
        msg_id = msg.get("id", "")

        if msg_id and msg_id in conn.message_ids:
            await self._send(conn.websocket, {
                "type": "duplicate",
                "message_id": msg_id,
            })
            return

        if msg_id:
            conn.message_ids.add(msg_id)
            await self._send(conn.websocket, {
                "type": "ack",
                "message_id": msg_id,
            })
            if len(conn.message_ids) > 1000:
                conn.message_ids.clear()

        if msg_type == "ping":
            conn.last_heartbeat = time.time()
            await self._send(conn.websocket, {"type": "pong"})
        elif msg_type == "resubscribe":
            topics = msg.get("topics", [])
            conn.subscribed_topics.update(topics)
            await self._send(conn.websocket, {
                "type": "resubscribed",
                "topics": list(conn.subscribed_topics),
            })
        elif msg_type == "subscribe":
            topic = msg.get("topic", "")
            if topic:
                conn.subscribed_topics.add(topic)
                await self._send(conn.websocket, {
                    "type": "subscribed",
                    "topic": topic,
                })
        elif msg_type == "unsubscribe":
            topic = msg.get("topic", "")
            conn.subscribed_topics.discard(topic)
        elif msg_type == "message":
            await process_fn(conn.websocket, msg, user_id, session_id)
        else:
            await self._send(conn.websocket, {
                "type": "error",
                "code": "unknown_type",
                "message": f"Unknown message type: {msg_type}",
            })

    async def _heartbeat_loop(self, user_id: str, session_id: str):
        while True:
            conn = self._connections.get(user_id, {}).get(session_id)
            if not conn:
                break
            await asyncio.sleep(self._heartbeat_interval)
            conn = self._connections.get(user_id, {}).get(session_id)
            if not conn:
                break

            elapsed = time.time() - conn.last_heartbeat
            if elapsed > self._ping_timeout:
                logger.warning("Heartbeat timeout", user_id=user_id, session_id=session_id)
                try:
                    await conn.websocket.close()
                except Exception:
                    pass
                break

    async def broadcast(self, user_id: str, message: dict):
        for session_id, conn in list(self._connections.get(user_id, {}).items()):
            try:
                await self._send(conn.websocket, message)
            except Exception:
                await self.disconnect(user_id, session_id)

    async def _send(self, websocket: WebSocket, message: dict):
        message["timestamp"] = time.time()
        await websocket.send_json(message)

    async def _send_error(self, websocket: WebSocket, code: str, message: str):
        await self._send(websocket, {
            "type": "error",
            "code": code,
            "message": message,
        })

    def get_active_connections(self, user_id: str) -> int:
        return len(self._connections.get(user_id, {}))

    def get_stats(self) -> dict:
        total = sum(len(conns) for conns in self._connections.values())
        return {
            "total_connections": total,
            "active_users": len(self._connections),
            "sessions": len(self._sessions),
        }


ws_manager = WebSocketManager()
