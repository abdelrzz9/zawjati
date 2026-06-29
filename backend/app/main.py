from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .llm import create_llm_client
from .store.conversation import ConversationStore
from .store.long_term import LongTermMemory
from .tools import ToolRegistry
from .chat import ChatService
from .router import router, create_chat_routes

app = FastAPI(
    title="Zawjati API",
    description="AI companion backend",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup():
    llm = create_llm_client()
    conversation_store = ConversationStore()
    memory_store = LongTermMemory()
    tool_registry = ToolRegistry()

    chat_service = ChatService(llm, conversation_store, memory_store, tool_registry)
    create_chat_routes(chat_service)
    app.include_router(router)


@app.get("/")
async def root():
    return {"message": "Zawjati API is running"}


@app.get("/health")
async def health():
    return {"status": "ok"}
