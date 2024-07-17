# pylint: disable=no-name-in-module
from pydantic import BaseModel, Field


class SystemInfo(BaseModel):
    version: str = Field(default="0.0.1")
    service: str = "todo"
    nickname: str = "todo"
    environment: str = "dev"
    deployed_at: str = "2024-07-11 14:52:15 UTC"
