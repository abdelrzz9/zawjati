# Architecture

## Overview

Zawjati follows a client-server architecture with a RESTful/WebSocket API.

```
┌──────────────┐     ┌──────────────┐     ┌──────────┐
│  Frontend    │────▶│   Backend    │────▶│   LLM    │
│ (Mobile/Web) │◀────│   (FastAPI)  │◀────│  (API)   │
└──────────────┘     └──────┬───────┘     └──────────┘
                            │
                    ┌───────┴───────┐
                    │   Memory DB   │
                    │  (SQLite/PG)  │
                    └───────────────┘
```

## Backend

- **Framework**: FastAPI (Python)
- **LLM Integration**: OpenAI / Anthropic / Local models
- **Memory**: SQLite for local, PostgreSQL for cloud
- **Speech**: Whisper (STT), ElevenLabs / Edge TTS

## Frontend

- **Mobile**: React Native or Flutter
- **Web**: React / Next.js

## Key Design Decisions

- Prompts are versioned and stored as markdown in `backend/prompts/`
- Memory is tiered: conversation (short-term) → preferences (long-term)
- Personality switching via prompt composition
