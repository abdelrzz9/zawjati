from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .api.router import router
from .api.deps import build_orchestrator

app = FastAPI(
    title="Zawjati API",
    description="AI companion platform",
    version="0.2.0",
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
    build_orchestrator()


@app.get("/")
async def root():
    return {
        "app": "Zawjati",
        "version": "0.2.0",
        "endpoints": {
            "chat": "POST /api/chat",
            "chat_stream": "POST /api/chat/stream",
            "chat_ws": "WS /api/chat/ws",
            "profile": "GET/POST /api/profile/{user_id}",
            "personalities": "GET /api/personalities",
            "metrics": "GET /api/metrics",
        },
    }


@app.get("/health")
async def health():
    return {"status": "ok"}
