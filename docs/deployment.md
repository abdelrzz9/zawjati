# Deployment Guide

## Production Architecture

```
                         ┌─────────────┐
                         │   CDN/CDN    │
                         │ (Cloudflare)  │
                         └──────┬──────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
              ┌─────▼─────┐          ┌──────▼──────┐
              │  Next.js   │          │  Flutter     │
              │  (Vercel)  │          │  (App Store) │
              └─────┬─────┘          └──────┬──────┘
                    │                       │
                    └───────────┬───────────┘
                                │
                         ┌──────▼──────┐
                         │   FastAPI    │
                         │  (Docker)    │
                         └──────┬──────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
              ┌─────▼─────┐          ┌──────▼──────┐
              │   Redis    │          │  PostgreSQL │
              │  (Cache)   │          │  (Optional) │
              └───────────┘          └─────────────┘
```

## Backend Deployment (Docker)

### Build and Run

```bash
# Build the image
docker build -t zawjati-backend:latest ./backend

# Run with environment
docker run -d \
  --name zawjati-backend \
  -p 8000:8000 \
  -e LLM_API_KEY=${LLM_API_KEY} \
  -e LLM_PROVIDER=openai \
  -e CORS_ORIGINS=https://yourdomain.com \
  -v ./prompts:/app/prompts:ro \
  -v data:/app/data \
  zawjati-backend:latest
```

### Docker Compose

```bash
docker compose up -d
```

### Environment Variables

| Variable                  | Required | Default           | Description                    |
|---------------------------|----------|-------------------|--------------------------------|
| `LLM_API_KEY`            | Yes      | —                 | LLM provider API key           |
| `LLM_PROVIDER`           | No       | `openai`          | LLM provider                   |
| `LLM_MODEL`              | No       | `gpt-4o-mini`     | Model name                     |
| `CORS_ORIGINS`           | No       | `*`               | Allowed origins (comma-sep)    |
| `RATE_LIMIT_PER_MINUTE`  | No       | `60`              | Rate limit per IP              |
| `LOG_LEVEL`              | No       | `INFO`            | Log level                      |
| `STREAMING_ENABLED`      | No       | `true`            | Enable streaming               |
| `ENABLE_MEMORY`          | No       | `true`            | Enable memory system           |

## Next.js Deployment (Vercel)

```bash
# Deploy to Vercel
npx vercel --prod

# Set environment variables
npx vercel env add NEXT_PUBLIC_API_URL
```

## Flutter Deployment

### Android

```bash
cd frontend/mobile
flutter build appbundle --release
# Upload to Google Play Console
```

### iOS

```bash
cd frontend/mobile
flutter build ios --release
# Open in Xcode and upload to App Store
```

## Health Checks

- `/health` — Liveness check (always returns 200)
- `/ready` — Readiness check (returns 503 if not ready)

## Monitoring

- `/api/metrics` — Prometheus metrics endpoint
- Structured JSON logs via stdout
- Request ID tracing via `X-Request-ID` header

## Rollback

```bash
# Docker rollback to previous version
docker pull ghcr.io/yourusername/zawjati/backend:previous-tag
docker stop zawjati-backend
docker run ... zawjati-backend:previous-tag
```

## Scaling

- Backend is stateless (memory stores are in-process by default)
- For horizontal scaling, configure external Redis/PostgreSQL
- Use a reverse proxy (nginx, Caddy) for SSL termination
- Enable gzip compression for API responses
