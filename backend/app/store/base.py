from abc import ABC, abstractmethod
from typing import Optional
from ..models import MemoryEntry


class MemoryStore(ABC):
    @abstractmethod
    async def add(self, user_id: str, entry: MemoryEntry):
        ...

    @abstractmethod
    async def add_batch(self, user_id: str, entries: list[MemoryEntry]):
        ...

    @abstractmethod
    async def query(self, user_id: str, query: str, limit: int = 10) -> list[MemoryEntry]:
        ...

    @abstractmethod
    async def get_by_category(self, user_id: str, category: str, limit: int = 20) -> list[MemoryEntry]:
        ...

    @abstractmethod
    async def clear(self, user_id: str):
        ...
