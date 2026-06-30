import time
import logging
import json
from contextlib import contextmanager
from dataclasses import dataclass, field
from datetime import datetime
from ..config import settings


@dataclass
class TraceMetrics:
    latency_ms: float = 0.0
    prompt_tokens: int = 0
    completion_tokens: int = 0
    total_tokens: int = 0
    cost: float = 0.0
    model: str = ""
    provider: str = ""
    memory_retrieval_ms: float = 0.0
    prompt_construction_ms: float = 0.0
    tool_execution_ms: float = 0.0


class StructuredFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }
        if hasattr(record, "extra"):
            log_entry.update(record.extra)
        if record.exc_info and record.exc_info[0]:
            log_entry["exception"] = self.formatException(record.exc_info)
        return json.dumps(log_entry)


class TextFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        ts = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
        return f"{ts} | {record.levelname:<5} | {record.getMessage()}"


class ObservabilityLogger:
    def __init__(self, name: str = "zawjati"):
        self.logger = logging.getLogger(name)
        self.logger.setLevel(settings.log_level.upper())
        self.logger.handlers.clear()

        handler = logging.StreamHandler()
        if settings.log_format == "json":
            handler.setFormatter(StructuredFormatter())
        else:
            handler.setFormatter(TextFormatter())
        self.logger.addHandler(handler)

    def log_chat(self, user_id: str, metrics: TraceMetrics, request_id: str = ""):
        self.logger.info(
            f"Chat response",
            extra={
                "extra": {
                    "request_id": request_id,
                    "user_id": user_id,
                    "model": metrics.model,
                    "provider": metrics.provider,
                    "latency_ms": round(metrics.latency_ms, 1),
                    "prompt_tokens": metrics.prompt_tokens,
                    "completion_tokens": metrics.completion_tokens,
                    "total_tokens": metrics.total_tokens,
                    "cost": round(metrics.cost, 6),
                    "memory_retrieval_ms": round(metrics.memory_retrieval_ms, 1),
                    "prompt_construction_ms": round(metrics.prompt_construction_ms, 1),
                    "tool_execution_ms": round(metrics.tool_execution_ms, 1),
                }
            },
        )

    def log_error(self, user_id: str, error: str, request_id: str = ""):
        self.logger.error(
            f"Error: {error}",
            extra={
                "extra": {
                    "request_id": request_id,
                    "user_id": user_id,
                    "error": error,
                }
            },
        )

    def info(self, msg: str, **extra):
        self.logger.info(msg, extra={"extra": extra})

    def warning(self, msg: str, **extra):
        self.logger.warning(msg, extra={"extra": extra})

    def error(self, msg: str, **extra):
        self.logger.error(msg, extra={"extra": extra})


@contextmanager
def timer():
    start = time.perf_counter()
    metric = {"elapsed": 0.0}
    yield metric
    metric["elapsed"] = (time.perf_counter() - start) * 1000
