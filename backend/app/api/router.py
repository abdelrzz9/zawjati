from fastapi import APIRouter, Request
from fastapi.responses import PlainTextResponse, JSONResponse
from ..models import UserProfile, ErrorDetail, ErrorResponse
from ..llm.base import LLMProviderError
from ..config import settings
from ..observability.metrics import metrics_collector
from .deps import get_orchestrator
from .chat import router as chat_router

router = APIRouter()
router.include_router(chat_router)


def _request_id(request: Request) -> str:
    return request.headers.get(settings.request_id_header, "")


@router.get("/profile/{user_id}", response_model=UserProfile)
async def get_profile(user_id: str, request: Request):
    orchestrator = get_orchestrator()
    try:
        return await orchestrator.profile.get(user_id)
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(
                error=ErrorDetail(code="profile_error", message=str(e), request_id=_request_id(request))
            ).model_dump(),
        )


@router.post("/profile/{user_id}")
async def update_profile(user_id: str, profile: UserProfile, request: Request):
    orchestrator = get_orchestrator()
    try:
        await orchestrator.profile.update(user_id, profile)
        return {"status": "ok"}
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(
                error=ErrorDetail(code="profile_error", message=str(e), request_id=_request_id(request))
            ).model_dump(),
        )


@router.get("/personalities")
async def list_personalities():
    orchestrator = get_orchestrator()
    return {"personalities": orchestrator.personalities.list_personalities()}


@router.get("/metrics/summary")
async def get_metrics_summary():
    return metrics_collector.summary


@router.get("/metrics")
async def get_metrics():
    prometheus = metrics_collector.get_prometheus_metrics()
    if prometheus:
        return PlainTextResponse(
            content=prometheus.decode("utf-8"),
            media_type="text/plain; charset=utf-8",
        )
    return metrics_collector.summary
