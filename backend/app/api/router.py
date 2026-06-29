from fastapi import APIRouter
from ..models import UserProfile
from .deps import get_orchestrator
from .chat import router as chat_router

router = APIRouter()
router.include_router(chat_router)


@router.get("/profile/{user_id}", response_model=UserProfile)
async def get_profile(user_id: str):
    orchestrator = get_orchestrator()
    return await orchestrator.profile.get(user_id)


@router.post("/profile/{user_id}")
async def update_profile(user_id: str, profile: UserProfile):
    orchestrator = get_orchestrator()
    await orchestrator.profile.update(user_id, profile)
    return {"status": "ok"}


@router.get("/personalities")
async def list_personalities():
    orchestrator = get_orchestrator()
    return {"personalities": orchestrator.personalities.list_personalities()}


@router.get("/metrics")
async def get_metrics():
    orchestrator = get_orchestrator()
    return orchestrator.metrics.summary
