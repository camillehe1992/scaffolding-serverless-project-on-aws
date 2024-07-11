# pylint: disable=consider-alternative-union-syntax
from typing import Union
from pydantic import BaseModel, Field


# We create a Pydantic model to define how Todo looks like. used for validation
class Todo(BaseModel):
    userId: int
    id_: Union[int] = Field(alias="id", default=None)
    title: str
    completed: bool
