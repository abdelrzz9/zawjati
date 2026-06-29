from typing import Optional
from ..models import UserProfile


class ProfileStore:
    def __init__(self):
        self._profiles: dict[str, UserProfile] = {}

    async def get(self, user_id: str) -> UserProfile:
        if user_id not in self._profiles:
            self._profiles[user_id] = UserProfile(user_id=user_id)
        return self._profiles[user_id]

    async def update(self, user_id: str, profile: UserProfile):
        self._profiles[user_id] = profile

    async def delete(self, user_id: str):
        self._profiles.pop(user_id, None)
