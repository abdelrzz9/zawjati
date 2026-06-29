# Architecture

## Overview

```
┌─────────────┐     ┌─────────────────────┐     ┌──────────────┐
│  Client      │────▶│   FastAPI Server    │────▶│  LLM Provider │
│ (App/Web)    │◀────│   (app.main)        │◀────│  (OpenAI/...) │
└─────────────┘     └──────────┬──────────┘     └──────────────┘
                               │
                    ┌──────────┴──────────┐
                    │    Core Engine      │
                    │  (framework-agnostic)│
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                 │
     ┌────────┴──────┐ ┌──────┴──────┐ ┌───────┴───────┐
     │  Prompt Builder│ │   Memory    │ │  Tool Registry│
     │  (composable)  │ │  (4 layers) │ │  (extensible) │
     └───────────────┘ └─────────────┘ └───────────────┘
```

Directory structure.

## Request Flow

1. **Receive** — FastAPI endpoint receives ChatRequest (JSON, SSE, or WebSocket)
2. **Retrieve** — RetrievalPipeline fetches conversation history + relevant memories
3. **Build** — PromptBuilder composes system prompt from base + safety + personality + context + memories + summary
4. **Generate** — LLMProvider generates response with optional tool calling
5. **Execute** — Tool calls are executed via ToolRegistry
6. **Extract** — Memory extraction parses structured memory markers from the response
7. **Store** — New memories are persisted to SemanticMemory / EpisodicMemory
8. **Respond** — Response is returned to the client with metrics

## Key Principles

- **Core is framework-agnostic** — `app/core/` has zero FastAPI imports; swap frameworks easily
- **Provider-agnostic LLM** — switch providers via `LLM_PROVIDER` env var
- **Composable prompts** — each section is independently replaceable
- **Memory-aware** — ranked retrieval with recency and confidence scoring
- **Observable** — every request logs latency, tokens, cost, timing breakdown
