from app.core.prompt_builder import PromptBuilder
from app.core.personality import PersonalityEngine


def _wife_content():
    return PersonalityEngine().load_personality("wife")


def _friend_content():
    return PersonalityEngine().load_personality("friend")


def _assistant_content():
    return PersonalityEngine().load_personality("assistant")


def _therapist_content():
    return PersonalityEngine().load_personality("therapist")


def test_build_base_components():
    pb = PromptBuilder()
    prompt = pb.build(personality="wife", personality_content=_wife_content())
    assert "Zawjati" in prompt
    assert "Relationship type: companion" in prompt
    assert "Current date and time" in prompt


def test_build_with_nickname():
    pb = PromptBuilder()
    prompt = pb.build(
        personality="friend",
        personality_content=_friend_content(),
        nickname="buddy",
        relationship_type="friend",
    )
    assert "buddy" in prompt
    assert "Use it naturally" in prompt


def test_build_with_memories():
    pb = PromptBuilder()
    prompt = pb.build(
        personality="assistant",
        personality_content=_assistant_content(),
        memories="- likes coffee\n- wants to travel",
    )
    assert "likes coffee" in prompt


def test_build_with_summary():
    pb = PromptBuilder()
    prompt = pb.build(
        personality="therapist",
        personality_content=_therapist_content(),
        conversation_summary="User talked about work stress",
    )
    assert "work stress" in prompt


def test_estimate_tokens():
    pb = PromptBuilder()
    text = "hello world " * 100
    estimated = pb.estimate_tokens(text)
    assert estimated > 0
    assert estimated < len(text)


def test_trim_to_fit():
    pb = PromptBuilder()
    long_text = "hello world " * 2000
    trimmed = pb.trim_to_fit(long_text, max_tokens=100)
    assert len(trimmed) < len(long_text)
    assert "truncated" in trimmed


def test_trim_not_needed():
    pb = PromptBuilder()
    short = "hello world"
    trimmed = pb.trim_to_fit(short, max_tokens=1000)
    assert trimmed == short


def test_reload():
    pb = PromptBuilder()
    pb._load("base")
    assert len(pb._cache) > 0
    pb.reload()
    assert len(pb._cache) == 0
