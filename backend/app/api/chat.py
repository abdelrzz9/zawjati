import json
import asyncio
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from fastapi.responses import StreamingResponse
from ..models import ChatRequest, ChatResponse
from .deps import get_orchestrator

router = APIRouter()


@router.post("/chat", response_model=ChatResponse)
async def chat_json(req: ChatRequest):
    orchestrator = get_orchestrator()
    reply = await orchestrator.process_message(req)
    return ChatResponse(reply=reply)


@router.post("/chat/stream")
async def chat_stream(req: ChatRequest):
    orchestrator = get_orchestrator()

    async def event_stream():
        yield "event: start\ndata: {}\n\n"
        async for token in orchestrator.process_message_stream(req):
            payload = json.dumps({"token": token})
            yield f"event: token\ndata: {payload}\n\n"
        yield "event: done\ndata: {}\n\n"

    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        },
    )


@router.websocket("/chat/ws")
async def chat_websocket(websocket: WebSocket):
    await websocket.accept()
    orchestrator = get_orchestrator()

    try:
        while True:
            data = await websocket.receive_text()
            try:
                body = json.loads(data)
                req = ChatRequest(**body)
            except json.JSONDecodeError:
                req = ChatRequest(message=data, user_id="ws_user")

            reply = await orchestrator.process_message(req)
            await websocket.send_json({"reply": reply, "type": "message"})
    except WebSocketDisconnect:
        pass
    except Exception as e:
        await websocket.send_json({"error": str(e), "type": "error"})
