# pylint: disable=no-name-in-module
from uuid import uuid4
from pydantic import BaseModel, Field


class User(BaseModel):
    id_: str = Field(alias="id", default_factory=lambda: uuid4().hex)
    email: str
    username: str
