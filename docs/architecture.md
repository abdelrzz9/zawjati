# Architecture

## System Design

Zawjati follows a clean architecture pattern with a clear separation of concerns:

```
┌──────────────────────────────────────────────────────┐
│                   API Layer (FastAPI)                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│  │  Chat    │ │  Profile │ │Personality│ │  Metrics │ │
│  │ Routes   │ │  Routes  │ │  Routes  │ │  Routes  │ │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ │
└───────┼────────────┼────────────┼────────────┼────────┘
        │            │            │            │
┌───────┼────────────┼────────────┼────────────┼────────┐
│       ▼            ▼            ▼            ▼        │
│  ┌──────────────────────────────────────────────────┐ │
│  │              Orchestrator Layer                   │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────┐ │ │
│  │  │   Chat   │ │  Memory  │ │  Tools   │ │Prompt│ │ │
│  │  │Orchestrat│ │ Pipeline │ │ Registry │ │Builder│ │ │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────┘ │ │
│  └──────────────────────────────────────────────────┘ │
│  Core Layer (zero framework imports)                   │
└────────────────────────────────────────────────────────┘
```

## Request Flow

```
Client                    API                     Core                    LLM/Store
  │                        │                        │                        │
  │── POST /chat ──────────►│                        │                        │
  │                        │── process_message() ───►│                        │
  │                        │                        │── retrieve memories ──►│
  │                        │                        │◄── memories ──────────│
  │                        │                        │                        │
  │                        │                        │── build_prompt() ──────│
  │                        │                        │── chat() ──────────────►│
  │                        │                        │◄── response ──────────│
  │                        │                        │                        │
  │                        │                        │── execute_tools() ─────│
  │                        │                        │── extract_memories() ──│
  │                        │◄── reply ─────────────│                        │
  │◄── response ──────────│                        │                        │
  │                        │                        │                        │
```

## Key Design Decisions

1. **Clean Architecture**: Core business logic has zero FastAPI imports, making it framework-agnostic and testable.

2. **Multi-Provider LLM**: Abstract `LLMProvider` base class allows switching between providers without changing orchestration logic.

3. **Memory Tiering**: 4-tier memory system (conversation history + episodic events + semantic facts + user profile) provides rich context while managing token budgets.

4. **Composable Prompts**: Modular prompt builder assembles system prompts from base identity, safety rules, personality, context, memories, and conversation summary.

5. **Tool System**: Extensible `BaseTool` with OpenAI function-calling format, tool registry for discovery, and output sanitization for security.

6. **In-Memory First**: Default in-memory stores for zero-dependency operation. External databases (Redis, PostgreSQL) can be swapped in for persistence and scaling.

7. **Observability by Design**: Structured logging, Prometheus metrics, request tracing, and performance timers built into the core request flow.

## Data Flow

### Chat Message Flow
1. Request received by API layer
2. Request ID assigned for tracing
3. Orchestrator retrieves user profile and personality
4. Retrieval pipeline fetches relevant memories
5. Prompt builder constructs system prompt
6. LLM provider generates response
7. Tool calls executed if present
8. Memories extracted from conversation
9. Response returned with metrics

### Memory Storage Flow
- **Conversation Store**: Maintains recent conversation history as list of turns
- **Episodic Memory**: Event-based memories with categories and importance scoring
- **Semantic Memory**: Deduplicated facts with confidence scores
- **Profile Store**: User preferences and settings
