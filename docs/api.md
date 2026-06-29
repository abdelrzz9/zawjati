# API Reference

## Base URL

`http://localhost:8000`

All responses include `X-Request-ID` header.

---

## Chat

### POST /api/chat

Send a message and receive a response.

```json
{
  "message": "How are you?",
  "user_id": "user123",
  "personality": "wife"
}
```

**Response:**

```json
{
  "reply": "I'm doing well, thank you!",
  "request_id": "abc123",
  "latency_ms": 450.2,
  "model": "gpt-4o-mini",
  "provider": "openai",
  "prompt_tokens": 120,
  "completion_tokens": 45,
  "total_tokens": 165,
  "cost": 0.000123
}
```

### POST /api/chat/stream

Server-Sent Events streaming response.

**Events:**

```
event: start
data: {"request_id": "abc123"}

event: token
data: {"token": "Hello"}

event: token
data: {"token": " how"}

event: token
data: {"token": " are"}

event: done
data: {}
```

### WS /api/chat/ws

WebSocket endpoint. Send JSON or plain text messages.

---

## Profile

### GET /api/profile/{user_id}

Get user profile (auto-creates with defaults).

### POST /api/profile/{user_id}

Update user profile.

```json
{
  "user_id": "user123",
  "nickname": "habibi",
  "relationship_type": "partner",
  "personality": "friend",
  "language": "en"
}
```

---

## Personalities

### GET /api/personalities

List available personality profiles.

```json
{
  "personalities": ["assistant", "friend", "therapist", "wife"]
}
```

---

## Metrics

### GET /api/metrics

Prometheus-formatted metrics (if prometheus_client installed).

### GET /api/metrics/summary

Aggregated metrics as JSON.

```json
{
  "total_requests": 42,
  "total_prompt_tokens": 12450,
  "total_completion_tokens": 3200,
  "total_tokens": 15650,
  "total_cost": 0.00873,
  "avg_latency_ms": 380.5,
  "avg_tokens_per_request": 372
}
```

---

## Health

### GET /health

Liveness check. Returns `{"status": "alive"}`.

### GET /live

Alias for /health.

### GET /ready

Readiness check. Returns `{"status": "ready"}` or 503.

---

## Error Format

```json
{
  "error": {
    "code": "rate_limit",
    "message": "Too many requests",
    "request_id": "abc123",
    "details": null
  }
}
```

Error codes: `rate_limit`, `provider_error`, `validation_error`, `internal_error`, `profile_error`.
