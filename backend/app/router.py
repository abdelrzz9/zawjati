from fastapi import APIRouter
from .models import ChatRequest, ChatResponse, UserProfile
from .chat import ChatService

router = APIRouter()

users: dict[str, UserProfile] = {}


def get_profile(user_id: str) -> UserProfile:
    if user_id not in users:
        users[user_id] = UserProfile(user_id=user_id)
    return users[user_id]


def create_chat_routes(chat_service: ChatService):
    @router.post("/chat", response_model=ChatResponse)
    async def chat(req: ChatRequest):
        profile = get_profile(req.user_id)
        reply = await chat_service.handle_message(
            req,
            nickname=profile.nickname,
            relationship_type=profile.relationship_type,
            personality=profile.personality_preference,
        )
        return ChatResponse(reply=reply)

    @router.get("/profile/{user_id}", response_model=UserProfile)
    async def get_profile(user_id: str):
        return get_profile(user_id)

    @router.post("/profile/{user_id}")
    async def update_profile(user_id: str, profile: UserProfile):
        users[user_id] = profile
        return {"status": "ok"}
