import time
import uuid
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .config import settings
from .api.router import router
from .api.deps import build_orchestrator
from .llm.base import LLMProviderError, RateLimitError
from .observability.logger import ObservabilityLogger
from .middleware import SecurityHeadersMiddleware

logger = ObservabilityLogger("zawjati")


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting Zawjati API", provider=settings.llm_provider)
    build_orchestrator()
    yield
    logger.info("Shutting down Zawjati API")


app = FastAPI(
    title="Zawjati API",
    description="AI companion platform",
    version="0.3.0",
    lifespan=lifespan,
)

cors_origins = [o.strip() for o in settings.cors_origins.split(",") if o.strip()]
app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(SecurityHeadersMiddleware)


@app.middleware("http")
async def add_request_id(request: Request, call_next):
    request_id = request.headers.get(settings.request_id_header) or uuid.uuid4().hex[:12]
    response = await call_next(request)
    response.headers[settings.request_id_header] = request_id
    return response


@app.middleware("http")
async def rate_limit_middleware(request: Request, call_next):
    from collections import defaultdict
    from datetime import datetime, timedelta

    client_ip = request.client.host if request.client else "unknown"
    now = datetime.now()
    window_key = f"{client_ip}:{now.strftime('%Y%m%d%H%M')}"

    if not hasattr(app.state, "_rate_limits"):
        app.state._rate_limits = defaultdict(list)

    limits = app.state._rate_limits[window_key]
    limits[:] = [t for t in limits if t > (now - timedelta(minutes=1)).timestamp()]
    limits.append(now.timestamp())

    if len(limits) > settings.rate_limit_per_minute:
        return JSONResponse(
            status_code=429,
            content={"error": {"code": "rate_limit", "message": "Too many requests. Try again in a minute."}},
        )

    return await call_next(request)


app.include_router(router, prefix="/api")


@app.get("/")
async def root():
    return {
        "app": "Zawjati",
        "version": "0.3.0",
        "endpoints": {
            "chat": "POST /api/chat",
            "chat_stream": "POST /api/chat/stream",
            "chat_ws": "WS /api/chat/ws",
            "profile": "GET/POST /api/profile/{user_id}",
            "personalities": "GET /api/personalities",
            "metrics": "GET /api/metrics",
            "health": "GET /health",
            "live": "GET /live",
            "ready": "GET /ready",
        },
    }


@app.get("/health")
@app.get("/live")
async def liveness():
    return {"status": "alive"}


@app.get("/ready")
async def readiness():
    try:
        build_orchestrator()
        return {"status": "ready"}
    except Exception as e:
        return JSONResponse(
            status_code=503,
            content={"status": "not_ready", "reason": str(e)},
        )
