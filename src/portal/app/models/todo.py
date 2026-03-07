# pylint: disable=no-name-in-module
import datetime
from uuid import uuid4
from pydantic import BaseModel, Field
from app.enum import BooleanStr


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
    completed: BooleanStr = Field(
        description="Todo completed status", default=BooleanStr.FALSE
    )
    created_at: datetime.datetime = Field(
        description="Todo created datetime", default_factory=datetime.datetime.now
    )
    updated_at: datetime.datetime = Field(
        description="Todo updated datetime", default_factory=datetime.datetime.now
    )
