import time
import logging
from functools import wraps
from typing import Callable, Any
from contextlib import contextmanager
from dataclasses import dataclass, field


@dataclass
class TraceMetrics:
    latency_ms: float = 0.0
    prompt_tokens: int = 0
    completion_tokens: int = 0
    cost: float = 0.0
    memory_retrieval_ms: float = 0.0
    tool_execution_ms: float = 0.0
    model: str = ""


class ObservabilityLogger:
    def __init__(self, name: str = "zawjati"):
        self.logger = logging.getLogger(name)
        self.logger.setLevel(logging.INFO)
        handler = logging.StreamHandler()
        handler.setFormatter(
            logging.Formatter("%(asctime)s | %(levelname)s | %(message)s")
        )
        if not self.logger.handlers:
            self.logger.addHandler(handler)

    def log_chat(self, user_id: str, metrics: TraceMetrics):
        self.logger.info(
            f"[{user_id}] model={metrics.model} "
            f"latency={metrics.latency_ms:.0f}ms "
            f"tokens={metrics.prompt_tokens}+{metrics.completion_tokens} "
            f"cost=${metrics.cost:.6f} "
            f"memory_retrieval={metrics.memory_retrieval_ms:.0f}ms "
            f"tools={metrics.tool_execution_ms:.0f}ms"
        )

    def log_error(self, user_id: str, error: str):
        self.logger.error(f"[{user_id}] {error}")


@contextmanager
def timer():
    start = time.perf_counter()
    metric = {"elapsed": 0.0}
    yield metric
    metric["elapsed"] = (time.perf_counter() - start) * 1000
