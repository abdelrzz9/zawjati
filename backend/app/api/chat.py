import json
import time
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Request
from fastapi.responses import StreamingResponse, JSONResponse
from ..models import ChatRequest, ChatResponse, ErrorDetail, ErrorResponse
from ..core.chat import ChatOrchestrator
from ..llm.base import LLMProviderError, RateLimitError
from ..config import settings
from ..observability.logger import timer
from .deps import get_orchestrator


router = APIRouter()


def _get_request_id(request: Request) -> str:
    header = settings.request_id_header
    return request.headers.get(header, "") if hasattr(request, "headers") else ""


def _error_response(code: str, message: str, request_id: str = "", status: int = 400) -> JSONResponse:
    return JSONResponse(
        status_code=status,
        content=ErrorResponse(
            error=ErrorDetail(code=code, message=message, request_id=request_id)
        ).model_dump(),
    )


@router.post("/chat", response_model=ChatResponse)
async def chat_json(req: ChatRequest, fastapi_request: Request):
    request_id = _get_request_id(fastapi_request)
    orchestrator = get_orchestrator()

    try:
        with timer() as total_timer:
            reply = await orchestrator.process_message(req, request_id=request_id)

        return ChatResponse(
            reply=reply,
            request_id=request_id,
            latency_ms=round(total_timer["elapsed"], 1),
        )
    except RateLimitError as e:
        return _error_response("rate_limit", str(e), request_id, 429)
    except LLMProviderError as e:
        return _error_response(e.code, str(e), request_id, e.status_code)
    except ValueError as e:
        return _error_response("validation_error", str(e), request_id, 400)
    except Exception as e:
        orchestrator.logger.log_error(req.user_id, str(e), request_id)
        return _error_response("internal_error", "An unexpected error occurred", request_id, 500)


@router.post("/chat/stream")
async def chat_stream(req: ChatRequest, fastapi_request: Request):
    request_id = _get_request_id(fastapi_request)
    orchestrator = get_orchestrator()

    async def event_stream():
        yield f"event: start\ndata: {json.dumps({'request_id': request_id})}\n\n"

        try:
            async for token in orchestrator.process_message_stream(req):
                payload = json.dumps({"token": token})
                yield f"event: token\ndata: {payload}\n\n"
            yield "event: done\ndata: {}\n\n"
        except LLMProviderError as e:
            payload = json.dumps({"code": e.code, "message": str(e)})
            yield f"event: error\ndata: {payload}\n\n"
        except Exception as e:
            orchestrator.logger.log_error(req.user_id, str(e), request_id)
            payload = json.dumps({"code": "internal_error", "message": "An unexpected error occurred"})
            yield f"event: error\ndata: {payload}\n\n"

    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
            "X-Request-ID": request_id,
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

            try:
                reply = await orchestrator.process_message(req)
                await websocket.send_json({"type": "message", "reply": reply})
            except LLMProviderError as e:
                await websocket.send_json({"type": "error", "code": e.code, "message": str(e)})
            except Exception as e:
                await websocket.send_json({"type": "error", "code": "internal_error", "message": str(e)})
    except WebSocketDisconnect:
        pass
