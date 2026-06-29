from collections import defaultdict
from dataclasses import dataclass, field
from datetime import datetime


@dataclass
class RequestMetrics:
    timestamp: datetime = field(default_factory=datetime.now)
    latency_ms: float = 0.0
    prompt_tokens: int = 0
    completion_tokens: int = 0
    cost: float = 0.0
    model: str = ""


class MetricsCollector:
    def __init__(self):
        self._requests: list[RequestMetrics] = []
        self._totals = defaultdict(float)

    def record(self, metrics: RequestMetrics):
        self._requests.append(metrics)
        self._totals["requests"] += 1
        self._totals["prompt_tokens"] += metrics.prompt_tokens
        self._totals["completion_tokens"] += metrics.completion_tokens
        self._totals["cost"] += metrics.cost
        self._totals["latency_ms"] += metrics.latency_ms

    @property
    def summary(self) -> dict:
        n = self._totals.get("requests", 1)
        return {
            "total_requests": int(self._totals["requests"]),
            "total_prompt_tokens": int(self._totals["prompt_tokens"]),
            "total_completion_tokens": int(self._totals["completion_tokens"]),
            "total_cost": round(self._totals["cost"], 6),
            "avg_latency_ms": round(self._totals["latency_ms"] / n, 1),
            "avg_tokens_per_request": int((self._totals["prompt_tokens"] + self._totals["completion_tokens"]) / n),
        }


metrics_collector = MetricsCollector()
