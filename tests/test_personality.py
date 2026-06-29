import pytest
from app.core.personality import PersonalityEngine


def test_load_personality():
    engine = PersonalityEngine()
    content = engine.load_personality("wife")
    assert "warm" in content.lower() or "Personality: Wife" in content


def test_list_personalities():
    engine = PersonalityEngine()
    personalities = engine.list_personalities()
    assert "wife" in personalities
    assert "friend" in personalities
    assert "assistant" in personalities
    assert "therapist" in personalities


def test_personality_not_found():
    engine = PersonalityEngine()
    with pytest.raises(FileNotFoundError):
        engine.load_personality("nonexistent")


def test_reload():
    engine = PersonalityEngine()
    engine.load_personality("wife")
    engine.reload("wife")
    assert "wife" not in engine._cache
    # Should load again
    content = engine.load_personality("wife")
    assert content is not None


def test_cache_hits():
    engine = PersonalityEngine()
    first = engine.load_personality("friend")
    second = engine.load_personality("friend")
    assert first == second
