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

The priorities below are ordered by execution sequence, not by number. Each phase depends on or enables the next.

## 1. Evaluation Framework
*Before improving quality, define how quality is measured.*

- [ ] Personality consistency benchmarks
- [ ] Memory accuracy benchmarks
- [ ] Hallucination rate tracking
- [ ] Response latency regression testing
- [ ] Tool-calling accuracy tests
- [ ] Long conversation quality evaluation
- [ ] Instruction following benchmarks
- [ ] Safety behavior testing
- [ ] Automated CI comparison between commits

## 2. Companion Quality
*The core product value — improved continuously, guided by evaluation.*

- [ ] Natural memory recall in conversation
- [ ] Adaptive communication style
- [ ] Repetition avoidance
- [ ] Personality consistency over months
- [ ] Balance of questions vs answers
- [ ] Warmth + honesty balance
- [ ] Healthy habits encouragement
- [ ] Transparent AI identity

## 3. Vector Memory
*Better retrieval directly improves long-term conversations and personalization.*

- [ ] Embedding provider abstraction
- [ ] pgvector or Qdrant integration
- [ ] Metadata filtering
- [ ] Hybrid search (semantic + keyword)
- [ ] Memory decay over time
- [ ] Importance score updates

## 4. Conversation Quality
*Add response review once retrieval is stronger.*

- [ ] Post-generation review pipeline
- [ ] Factual consistency checking
- [ ] Repetition detection
- [ ] Tone consistency validation
- [ ] Grammar and verbosity scoring
- [ ] Memory contradiction detection
- [ ] Automatic regeneration below quality threshold

## 5. User Profiles
*Personalization without changing the core architecture.*

- [ ] Expanded preferences (language, tone, response length, emoji frequency, etc.)
- [ ] Timezone and date format support
- [ ] Units system (metric/imperial)
- [ ] Automatic prompt construction from preferences

## 6. Knowledge & Retrieval (RAG)
*Conversational memory captures information about the user; retrieval grounds answers in external documents.*

- [ ] PDF, Markdown, DOCX, text file uploads
- [ ] Personal knowledge bases
- [ ] Semantic document search
- [ ] Source attribution and citations
- [ ] Per-user document collections
- [ ] Document chunking and re-indexing
- [ ] Versioning when documents change

## 7. Voice Mode
*Major user-facing feature once text interactions are solid.*

- [ ] Speech-to-Text integration
- [ ] Streaming LLM + TTS
- [ ] Interruption handling
- [ ] Low-latency streaming
- [ ] Configurable voices

## 8. Mobile Support
*Important when building mobile clients.*

- [ ] Pagination and cursor-based history
- [ ] Offline synchronization
- [ ] Attachment uploads
- [ ] Image support
- [ ] Resumable streaming

## 9. Developer Experience
*Improve tooling as the project grows.*

- [ ] OpenAPI examples
- [ ] Makefile
- [ ] Ruff + Black + mypy
- [ ] GitHub Actions CI
- [ ] Dependabot
- [ ] Semantic versioning
- [ ] Automatic releases

## 10. Dashboard
*Valuable for monitoring usage and costs in production.*

- [ ] Active sessions monitor
- [ ] Request latency + token usage charts
- [ ] Provider distribution
- [ ] Error rates
- [ ] Memory statistics
- [ ] Tool usage tracking
- [ ] Cost estimation

## 11. Cost Optimization
*Token costs grow with usage — optimize early.*

- [ ] Prompt caching
- [ ] Response caching for deterministic requests
- [ ] Automatic model routing (small model for simple tasks, large for complex reasoning)
- [ ] Token budgeting and prompt compression
- [ ] Batch processing where applicable
- [ ] Cost analytics and per-user usage tracking

## 12. Multi-Agent Architecture
*Keep last. A well-designed single-agent system with good memory and tools is often simpler, faster, and easier to maintain. Only introduce specialized agents if orchestration solves a clear limitation.*

- [ ] Agent definitions (Conversation, Memory, Planner, Research, Tool, Reflection)
- [ ] Orchestrator coordination
- [ ] Complex task decomposition
