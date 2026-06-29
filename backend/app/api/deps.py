from ..config import settings
from ..llm import create_llm_provider
from ..core.chat import ChatOrchestrator
from ..core.personality import PersonalityEngine
from ..store.conversation import ConversationStore
from ..store.episodic import EpisodicMemory
from ..store.semantic import SemanticMemory
from ..store.profile import ProfileStore
from ..tools.registry import ToolRegistry
from ..tools.weather import WeatherTool
from ..tools.calculator import CalculatorTool
from ..tools.notes import NotesTool
from ..tools.reminders import RemindersTool
from ..tools.search import WebSearchTool
from ..tools.image_gen import ImageGenTool
from ..observability.logger import ObservabilityLogger
from ..observability.metrics import MetricsCollector


_orchestrator: ChatOrchestrator | None = None


def build_orchestrator() -> ChatOrchestrator:
    global _orchestrator
    if _orchestrator:
        return _orchestrator

    llm = create_llm_provider()

    tool_registry = ToolRegistry()
    tool_registry.register_all(
        WeatherTool(),
        CalculatorTool(),
        NotesTool(),
        RemindersTool(),
        WebSearchTool(),
        ImageGenTool(),
    )

    _orchestrator = ChatOrchestrator(
        llm=llm,
        conversation_store=ConversationStore(),
        episodic_store=EpisodicMemory(),
        semantic_store=SemanticMemory(),
        profile_store=ProfileStore(),
        tool_registry=tool_registry,
        personality_engine=PersonalityEngine(),
        logger=ObservabilityLogger(),
        metrics=MetricsCollector(),
    )

    return _orchestrator


def get_orchestrator() -> ChatOrchestrator:
    return build_orchestrator()
