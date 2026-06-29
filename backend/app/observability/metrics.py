from collections import defaultdict
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

try:
    from prometheus_client import Counter, Histogram, Gauge, generate_latest, REGISTRY
    PROMETHEUS_AVAILABLE = True
except ImportError:
    PROMETHEUS_AVAILABLE = False


@dataclass
class RequestMetrics:
    timestamp: datetime = field(default_factory=datetime.now)
    latency_ms: float = 0.0
    prompt_tokens: int = 0
    completion_tokens: int = 0
    total_tokens: int = 0
    cost: float = 0.0
    model: str = ""
    provider: str = ""


class MetricsCollector:
    def __init__(self):
        self._requests: list[RequestMetrics] = []
        self._totals = defaultdict(float)
        self._setup_prometheus()

    def _setup_prometheus(self):
        if not PROMETHEUS_AVAILABLE:
            return
        self._prom_latency = Histogram(
            "zawjati_chat_latency_ms", "Chat response latency in ms",
            buckets=[100, 250, 500, 1000, 2000, 5000, 10000],
        )
        self._prom_tokens = Counter(
            "zawjati_tokens_total", "Total tokens used",
            ["type"],
        )
        self._prom_cost = Counter(
            "zawjati_cost_total", "Total cost in USD",
        )
        self._prom_requests = Counter(
            "zawjati_requests_total", "Total chat requests",
            ["model", "provider"],
        )
        self._prom_memory_retrieval = Histogram(
            "zawjati_memory_retrieval_ms", "Memory retrieval latency",
            buckets=[5, 10, 25, 50, 100, 250, 500],
        )

    def record(self, metrics: RequestMetrics):
        self._requests.append(metrics)
        self._totals["requests"] += 1
        self._totals["prompt_tokens"] += metrics.prompt_tokens
        self._totals["completion_tokens"] += metrics.completion_tokens
        self._totals["total_tokens"] += metrics.total_tokens
        self._totals["cost"] += metrics.cost
        self._totals["latency_ms"] += metrics.latency_ms

        if PROMETHEUS_AVAILABLE and hasattr(self, "_prom_latency"):
            self._prom_latency.observe(metrics.latency_ms)
            self._prom_tokens.labels(type="prompt").inc(metrics.prompt_tokens)
            self._prom_tokens.labels(type="completion").inc(metrics.completion_tokens)
            self._prom_tokens.labels(type="total").inc(metrics.total_tokens)
            self._prom_cost.inc(metrics.cost)
            self._prom_requests.labels(
                model=metrics.model or "unknown",
                provider=metrics.provider or "unknown",
            ).inc()

    def get_prometheus_metrics(self) -> Optional[bytes]:
        if PROMETHEUS_AVAILABLE:
            return generate_latest(REGISTRY)
        return None

    @property
    def summary(self) -> dict:
        n = self._totals.get("requests", 1)
        return {
            "total_requests": int(self._totals["requests"]),
            "total_prompt_tokens": int(self._totals["prompt_tokens"]),
            "total_completion_tokens": int(self._totals["completion_tokens"]),
            "total_tokens": int(self._totals["total_tokens"]),
            "total_cost": round(self._totals["cost"], 6),
            "avg_latency_ms": round(self._totals["latency_ms"] / n, 1),
            "avg_tokens_per_request": int(self._totals["total_tokens"] / n) if n else 0,
        }


metrics_collector = MetricsCollector()
