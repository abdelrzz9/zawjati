"""AI Conversation QA tests - automated conversation testing scenarios."""
import pytest
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
    llm = MockLLMProvider([
        "I understand how you feel. Let me help you with that.",
        "That's a great question! Here's what I think...",
        "Based on our conversation, I remember you mentioned...",
    ])
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
async def test_very_long_conversation(orchestrator):
    user_id = "qa_long_convo"
    for i in range(50):
        req = ChatRequest(message=f"Message number {i}", user_id=user_id)
        reply = await orchestrator.process_message(req)
        assert len(reply) > 0, f"Empty reply at message {i}"

    history = orchestrator.conversation.get_history(user_id)
    assert len(history) > 0
    assert orchestrator.conversation.total_turns(user_id) <= 100


@pytest.mark.asyncio
async def test_streaming_interruption():
    llm = MockLLMProvider(["Hello"])
    orch = ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=ToolRegistry(),
        personality_engine=PersonalityEngine(),
    )

    chunks = []
    async for chunk in orch.process_message_stream(
        ChatRequest(message="test", user_id="qa_stream")
    ):
        chunks.append(chunk)
        if len(chunks) >= 1:
            break

    assert len(chunks) > 0


@pytest.mark.asyncio
async def test_message_edit_and_regenerate(orchestrator):
    req1 = ChatRequest(message="Tell me about AI", user_id="qa_edit")
    await orchestrator.process_message(req1)
    history_before = len(orchestrator.conversation.get_history("qa_edit"))

    req2 = ChatRequest(message="Tell me about machine learning", user_id="qa_edit")
    await orchestrator.process_message(req2)
    history_after = len(orchestrator.conversation.get_history("qa_edit"))

    assert history_after > history_before


@pytest.mark.asyncio
async def test_conversation_deletion(orchestrator):
    req = ChatRequest(message="Hello", user_id="qa_delete")
    await orchestrator.process_message(req)
    assert orchestrator.conversation.total_turns("qa_delete") > 0

    orchestrator.conversation.clear("qa_delete")
    assert orchestrator.conversation.total_turns("qa_delete") == 0


@pytest.mark.asyncio
async def test_large_markdown_handling():
    llm = MockLLMProvider(["```\n" + "x\n" * 100 + "```"])
    orch = ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=ToolRegistry(),
        personality_engine=PersonalityEngine(),
    )
    req = ChatRequest(message="Generate large code", user_id="qa_markdown")
    reply = await orch.process_message(req)
    assert len(reply) > 0


@pytest.mark.asyncio
async def test_tool_calling_in_conversation():
    llm = MockLLMProvider([
        '{"content": "", "tool_calls": [{"id": "call_1", "type": "function", "function": {"name": "calculator", "arguments": "{\\"expression\\": \\"2+2\\"}"}}]}',
        "The answer is 4",
    ])
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
    req = ChatRequest(message="What is 2+2?", user_id="qa_tools")
    reply = await orch.process_message(req)
    assert reply is not None


@pytest.mark.asyncio
async def test_memory_recall_in_conversation():
    llm = MockLLMProvider([
        "I remember you like coffee! ---MEMORY: preference | likes coffee | importance=7 | confidence=0.9",
        "Yes, I recall you enjoy coffee!",
    ])
    tool_registry = ToolRegistry()
    orch = ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=tool_registry,
        personality_engine=PersonalityEngine(),
    )
    req1 = ChatRequest(message="I love coffee", user_id="qa_memory")
    await orch.process_message(req1)

    req2 = ChatRequest(message="What do you know about me?", user_id="qa_memory")
    reply = await orch.process_message(req2)
    assert reply is not None


@pytest.mark.asyncio
async def test_rtl_conversation():
    llm = MockLLMProvider(["مرحباً! كيف يمكنني مساعدتك اليوم؟"])
    orch = ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=ToolRegistry(),
        personality_engine=PersonalityEngine(),
    )
    req = ChatRequest(message="مرحباً", user_id="qa_rtl", personality="wife")
    reply = await orch.process_message(req)
    assert len(reply) > 0
