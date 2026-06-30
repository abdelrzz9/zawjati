# Roadmap

## ✓ Phase 1 — Foundation
- [x] Project structure and Git setup
- [x] Core prompts (base, safety, personalities)
- [x] FastAPI server with lifespan
- [x] LLM integration with multi-provider support
- [x] Short-term conversation memory
- [x] Personality switching
- [x] Streaming (JSON, SSE, WebSocket)
- [x] Tool calling architecture

## ✓ Phase 2 — Intelligence
- [x] Long-term memory (semantic + episodic)
- [x] Memory extraction from conversations
- [x] Ranked memory retrieval with recency scoring
- [x] Dynamic prompt composition
- [x] Conversation summarization
- [x] Context window management

## ✓ Phase 3 — Production Hardening
- [x] Retry logic with exponential backoff
- [x] Rate limit handling (LLM + HTTP)
- [x] Request ID tracing
- [x] Structured JSON logging
- [x] Prometheus metrics
- [x] Input validation
- [x] CORS configuration
- [x] Error response format

---

## P1 — Evaluation Framework
- [ ] Personality consistency benchmarks
- [ ] Memory accuracy benchmarks
- [ ] Hallucination rate tracking
- [ ] Response latency regression testing
- [ ] Tool-calling accuracy tests
- [ ] Long conversation quality evaluation
- [ ] Instruction following benchmarks
- [ ] Safety behavior testing
- [ ] Automated CI comparison between commits

## P2 — Conversation Quality
- [ ] Post-generation review pipeline
- [ ] Factual consistency checking
- [ ] Repetition detection
- [ ] Tone consistency validation
- [ ] Grammar and verbosity scoring
- [ ] Memory contradiction detection
- [ ] Automatic regeneration below quality threshold

## P3 — Vector Memory
- [ ] Embedding provider abstraction
- [ ] pgvector or Qdrant integration
- [ ] Metadata filtering
- [ ] Hybrid search (semantic + keyword)
- [ ] Memory decay over time
- [ ] Importance score updates

## P4 — User Profiles
- [ ] Expanded preferences (language, tone, response length, emoji frequency, etc.)
- [ ] Timezone and date format support
- [ ] Units system (metric/imperial)
- [ ] Automatic prompt construction from preferences

## P5 — Voice Mode
- [ ] Speech-to-Text integration
- [ ] Streaming LLM + TTS
- [ ] Interruption handling
- [ ] Low-latency streaming
- [ ] Configurable voices

## P6 — Mobile Support
- [ ] Pagination and cursor-based history
- [ ] Offline synchronization
- [ ] Attachment uploads
- [ ] Image support
- [ ] Resumable streaming

## P7 — Multi-Agent Architecture
- [ ] Agent definitions (Conversation, Memory, Planner, Research, Tool, Reflection)
- [ ] Orchestrator coordination
- [ ] Complex task decomposition

## P8 — Developer Experience
- [ ] OpenAPI examples
- [ ] Makefile
- [ ] Ruff + Black + mypy
- [ ] GitHub Actions CI
- [ ] Dependabot
- [ ] Semantic versioning
- [ ] Automatic releases

## P9 — Dashboard
- [ ] Active sessions monitor
- [ ] Request latency + token usage charts
- [ ] Provider distribution
- [ ] Error rates
- [ ] Memory statistics
- [ ] Tool usage tracking
- [ ] Cost estimation

## P10 — Companion Quality
- [ ] Natural memory recall in conversation
- [ ] Adaptive communication style
- [ ] Repetition avoidance
- [ ] Personality consistency over months
- [ ] Balance of questions vs answers
- [ ] Warmth + honesty balance
- [ ] Healthy habits encouragement
- [ ] Transparent AI identity
