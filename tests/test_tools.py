import pytest
from app.tools.calculator import CalculatorTool
from app.tools.notes import NotesTool
from app.tools.reminders import RemindersTool
from app.tools.weather import WeatherTool
from app.tools.search import WebSearchTool
from app.tools.registry import ToolRegistry


@pytest.mark.asyncio
async def test_calculator_basic():
    tool = CalculatorTool()
    assert await tool.execute(expression="2 + 2") == "4"


@pytest.mark.asyncio
async def test_calculator_complex():
    tool = CalculatorTool()
    result = await tool.execute(expression="3 * 4 + 2")
    assert float(result) == 14.0


@pytest.mark.asyncio
async def test_calculator_division():
    tool = CalculatorTool()
    result = await tool.execute(expression="10 / 2")
    assert float(result) == 5.0


@pytest.mark.asyncio
async def test_calculator_sqrt():
    tool = CalculatorTool()
    result = await tool.execute(expression="__import__('os').system('echo hacked')")
    assert "Error" in result


@pytest.mark.asyncio
async def test_calculator_invalid():
    tool = CalculatorTool()
    result = await tool.execute(expression="not math")
    assert "Error" in result


@pytest.mark.asyncio
async def test_notes_save_and_retrieve():
    tool = NotesTool()
    save = await tool.execute(action="save", title="memo", content="buy milk")
    assert "saved" in save.lower()

    get = await tool.execute(action="get", title="memo")
    assert "buy milk" in get


@pytest.mark.asyncio
async def test_notes_list():
    tool = NotesTool()
    await tool.execute(action="save", title="a", content="1")
    await tool.execute(action="save", title="b", content="2")
    result = await tool.execute(action="list")
    assert "a" in result and "b" in result


@pytest.mark.asyncio
async def test_notes_delete():
    tool = NotesTool()
    await tool.execute(action="save", title="temp", content="temp")
    await tool.execute(action="delete", title="temp")
    result = await tool.execute(action="get", title="temp")
    assert "not found" in result.lower()


@pytest.mark.asyncio
async def test_reminders_set_and_list():
    tool = RemindersTool()
    await tool.execute(action="set", text="call doctor")
    result = await tool.execute(action="list")
    assert "call doctor" in result


@pytest.mark.asyncio
async def test_reminders_done():
    tool = RemindersTool()
    await tool.execute(action="set", text="test task")
    result = await tool.execute(action="done", text="1")
    assert "done" in result.lower()


@pytest.mark.asyncio
async def test_weather_stub():
    tool = WeatherTool()
    result = await tool.execute(location="London")
    assert "not yet implemented" in result


@pytest.mark.asyncio
async def test_search_stub():
    tool = WebSearchTool()
    result = await tool.execute(query="python")
    assert "not yet implemented" in result


@pytest.mark.asyncio
async def test_tool_registry():
    registry = ToolRegistry()
    registry.register(CalculatorTool())
    registry.register(NotesTool())

    assert len(registry.get_all()) == 2
    assert len(registry.get_openai_tools()) == 2

    assert registry.get("calculator") is not None
    assert registry.get("nonexistent") is None

    result = await registry.execute("calculator", {"expression": "1+1"})
    assert result == "2"

    not_found = await registry.execute("nope", {})
    assert "not found" in not_found


def test_tool_openai_format():
    tool = CalculatorTool()
    fmt = tool.to_openai_format()
    assert fmt["type"] == "function"
    assert fmt["function"]["name"] == "calculator"
    assert "parameters" in fmt["function"]


def test_tool_sanitize_output():
    from app.tools.base import BaseTool

    class TestTool(BaseTool):
        name = "test"
        description = "test"
        parameters = {}

        async def execute(self, **kwargs):
            return ""

    t = TestTool()
    assert t.sanitize_output("<script>alert(1)</script>") == "scriptalert(1)/script"
    assert t.sanitize_output("  hello   world  ") == "hello world"
    assert t.sanitize_output("") == ""
