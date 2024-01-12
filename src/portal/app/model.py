# pylint: disable=consider-alternative-union-syntax
from typing import Optional
from pydantic import BaseModel, Field


# We create a Pydantic model to define how Todo looks like. used for validation
class Todo(BaseModel):
    userId: int
    id_: Optional[int] = Field(alias="id", default=None)
    title: str
    completed: bool
