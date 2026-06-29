"""Integration tests for chat orchestrator using mock LLM."""
import pytest
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "backend"))

from app.core.chat import ChatOrchestrator
from app.core.personality import PersonalityEngine
from app.store.conversation import ConversationStore
from app.store.episodic import EpisodicMemory
from app.store.semantic import SemanticMemory
from app.store.profile import ProfileStore
from app.tools.registry import ToolRegistry
from app.tools.calculator import CalculatorTool
from app.tools.notes import NotesTool
from app.models import ChatRequest
from tests.test_llm import MockLLMProvider


@pytest.fixture
def orchestrator():
    llm = MockLLMProvider(["Hello! How can I help you today?"])
    tool_registry = ToolRegistry()
    tool_registry.register_all(CalculatorTool(), NotesTool())

    return ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=tool_registry,
        personality_engine=PersonalityEngine(),
    )


@pytest.mark.asyncio
async def test_process_message(orchestrator):
    req = ChatRequest(message="hello", user_id="test_user")
    reply = await orchestrator.process_message(req)
    assert len(reply) > 0
    assert "Hello" in reply or "hello" in reply.lower()


@pytest.mark.asyncio
async def test_process_message_stream(orchestrator):
    req = ChatRequest(message="hi", user_id="test_user")
    chunks = []
    async for chunk in orchestrator.process_message_stream(req):
        chunks.append(chunk)
    full = "".join(chunks)
    assert len(full) > 0


@pytest.mark.asyncio
async def test_conversation_persistence(orchestrator):
    req1 = ChatRequest(message="first message", user_id="u1")
    await orchestrator.process_message(req1)
    history = orchestrator.conversation.get_history("u1")
    assert len(history) == 2  # user + assistant

    req2 = ChatRequest(message="second message", user_id="u1")
    await orchestrator.process_message(req2)
    history = orchestrator.conversation.get_history("u1")
    assert len(history) == 4  # 2 user + 2 assistant


@pytest.mark.asyncio
async def test_personality_switching(orchestrator):
    req_friend = ChatRequest(message="hello", user_id="u1", personality="friend")
    reply = await orchestrator.process_message(req_friend)
    assert reply is not None


@pytest.mark.asyncio
async def test_memory_extraction(orchestrator):
    """Test that memory extraction runs without errors."""
    llm = MockLLMProvider(["I see you like coffee! ---MEMORY: preference | likes coffee | importance=7 | confidence=0.9"])
    tool_registry = ToolRegistry()
    tool_registry.register(CalculatorTool())

    orch = ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=tool_registry,
        personality_engine=PersonalityEngine(),
    )

    req = ChatRequest(message="I love coffee", user_id="u1")
    await orch.process_message(req)
    # Memory should have been extracted from the ---MEMORY--- block
    # Just verify no errors, the extraction is best-effort
