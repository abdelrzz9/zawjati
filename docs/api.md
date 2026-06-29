# API Reference

Coming soon. Endpoints will include:

## Chat
- `POST /api/chat` — Send a message, get a response
- `GET /api/chat/history` — Get conversation history

## Memory
- `GET /api/memory` — Get stored memories
- `POST /api/memory` — Store a memory
- `DELETE /api/memory/:id` — Delete a memory

## Personality
- `GET /api/personalities` — List available personalities
- `POST /api/personality/switch` — Switch personality

## User
- `POST /api/user` — Create user profile
- `GET /api/user/:id` — Get user data

## Voice
- `POST /api/voice/stt` — Speech to text
- `POST /api/voice/tts` — Text to speech
