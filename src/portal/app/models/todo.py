# pylint: disable=no-name-in-module
from datetime import datetime
from uuid import uuid4
from pydantic import BaseModel, Field


class Todo(BaseModel):
    id_: str = Field(
        alias="id",
        default_factory=lambda: uuid4().hex,
        examples=["bfc7adb5-fd97-473d-a10f-29cf8b48811d"],
    )
    user_id: str = Field(
        description="User ID", example="bfc7adb5-fd97-473d-a10f-29cf8b48811d"
    )
    title: str = Field(description="Todo title", example="delectus aut autem")
    completed: bool = Field(description="Todo completed status")
    created_at: datetime = Field(
        description="Todo created datetime",
        default_factory=datetime.now,
        example="2023-01-01T00:00:00Z",
    )
    updated_at: datetime = Field(
        description="Todo updated datetime",
        default_factory=datetime.now,
        example="2023-01-01T00:00:00Z",
    )
