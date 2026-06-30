# Zawjati — AI Companion Platform

[![CI](https://github.com/yourusername/zawjati/actions/workflows/ci.yml/badge.svg)](https://github.com/yourusername/zawjati/actions/workflows/ci.yml)
[![Release](https://github.com/yourusername/zawjati/actions/workflows/release.yml/badge.svg)](https://github.com/yourusername/zawjati/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![codecov](https://codecov.io/gh/yourusername/zawjati/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/zawjati)

Zawjati is an intelligent AI companion platform that learns from every conversation. It features a modular architecture supporting multiple LLM providers, a sophisticated memory system, personality customization, and cross-platform frontends.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend Layer                        │
│  ┌─────────────────┐  ┌──────────────────────────────┐  │
│  │   Flutter App    │  │        Next.js Web App        │  │
│  │  (iOS/Android)   │  │     (Responsive SPA)          │  │
│  └────────┬─────────┘  └──────────────┬───────────────┘  │
└───────────┼────────────────────────────┼──────────────────┘
            │           REST/WS          │
┌───────────┼────────────────────────────┼──────────────────┐
│           ▼                            ▼                  │
│  ┌──────────────────────────────────────────────────┐    │
│  │              FastAPI Backend (Python)             │    │
│  │  ┌─────────┐ ┌──────────┐ ┌─────────┐ ┌──────┐  │    │
│  │  │ Chat    │ │ Memory   │ │ Tools   │ │ LLM  │  │    │
│  │  │ Engine  │ │ System   │ │ System  │ │ Prov.│  │    │
│  │  └─────────┘ └──────────┘ └─────────┘ └──────┘  │    │
│  └──────────────────────────────────────────────────┘    │
│  Backend Layer                                             │
└───────────────────────────────────────────────────────────┘
```

## Features

- **Multi-Provider LLM**: OpenAI, Anthropic, Gemini, Ollama, OpenRouter, Groq
- **Memory System**: 4-tier memory (conversation, episodic, semantic, profile)
- **Personalities**: Customizable personality profiles with markdown-based prompts
- **Tool System**: Extensible tool registry (calculator, notes, reminders, weather, search, image gen)
- **Streaming Chat**: SSE streaming and WebSocket support
- **Voice**: Speech-to-text and text-to-speech (Flutter)
- **Authentication**: JWT-based with refresh token rotation
- **Offline Support**: Local-first architecture with sync capabilities
- **Real-time**: WebSocket with reconnect, heartbeat, and duplicate prevention
- **Internationalization**: English, Arabic, French with RTL support
- **Accessibility**: WCAG AA compliant, screen reader support, keyboard navigation
- **Security**: CSP, HSTS, rate limiting, input validation, output sanitization
- **Observability**: Structured JSON logging, Prometheus metrics, request tracing

## Tech Stack

| Component  | Technology                                      |
|------------|-------------------------------------------------|
| Backend    | Python 3.12, FastAPI, Pydantic, Uvicorn         |
| LLM        | OpenAI, Anthropic, Google Gemini, Ollama, etc.  |
| Memory     | In-memory (extensible to Redis, SQLite)         |
| Mobile     | Flutter 3.x, BLoC, GetIt, GoRouter              |
| Web        | Next.js 15, React 19, TanStack Query, Zustand   |
| Styling    | Tailwind CSS 4 (web), Material 3 (mobile)       |
| Auth       | JWT, Google Sign-In, Apple Sign-In              |
| Testing    | pytest, flutter_test, bloc_test, Vitest, Playwright |
| CI/CD      | GitHub Actions                                  |
| Container  | Docker, Docker Compose                          |

## Getting Started

### Prerequisites

- Python 3.12+
- Flutter SDK 3.11+
- Node.js 22+
- Docker (optional)

### Backend

```bash
cd backend
cp .env.example .env
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### Flutter Mobile

```bash
cd frontend/mobile
cp .env.example .env
flutter pub get
flutter run
```

### Next.js Web

```bash
cd frontend/web
npm install
cp .env.local.example .env.local
npm run dev
```

### Docker

```bash
docker compose up
```

## Testing

```bash
# Backend
cd backend && pip install -r requirements.txt && cd ..
pytest tests/ -v --cov=backend.app

# Flutter
cd frontend/mobile && flutter test --coverage

# Next.js
cd frontend/web && npm test && npm run e2e
```

## API

Full API documentation: [docs/api.md](docs/api.md)

### Endpoints

| Endpoint          | Method | Description              |
|-------------------|--------|--------------------------|
| `/health`         | GET    | Liveness check           |
| `/ready`          | GET    | Readiness check          |
| `/api/chat`       | POST   | Send chat message        |
| `/api/chat/stream`| POST   | SSE streaming chat       |
| `/api/chat/ws`    | WS     | WebSocket chat           |
| `/api/profile/*`  | GET/POST | User profile CRUD      |
| `/api/personalities` | GET | List personalities     |
| `/api/metrics`    | GET    | Prometheus metrics       |

## Project Structure

```
zawjati/
├── backend/
│   └── app/
│       ├── api/          # API routes
│       ├── core/         # Business logic
│       ├── llm/          # LLM providers
│       ├── store/        # Memory stores
│       ├── tools/        # Tool system
│       └── observability/# Logging & metrics
├── frontend/
│   ├── mobile/           # Flutter app
│   └── web/              # Next.js app
├── tests/                # Backend tests
├── docs/                 # Documentation
└── .github/              # CI/CD & templates
```

## Deployment

See [docs/deployment.md](docs/deployment.md) for production deployment instructions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## Security

See [SECURITY.md](SECURITY.md) for security policies and vulnerability reporting.

## License

MIT License — see [LICENSE](LICENSE) for details.
