from typing import Union
import requests
from aws_lambda_powertools.event_handler import Response
from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.openapi.params import Body, Query
from aws_lambda_powertools.shared.types import Annotated

from ..logging import logger
from ..models import Todo


# Constants
DEMO_API_URL = "https://jsonplaceholder.typicode.com"
TIMEOUT_IN_SECONDS = 60


router = Router()


# List all todos
@router.get("/todos", tags=["Todo"], summary="Get all todos")
def get_todos(
    completed: Annotated[Union[str, int], Query(min_length=4)] = None
) -> list[Todo]:
    url = f"{DEMO_API_URL}/todos"
    if completed is not None:
        url = f"{url}/?completed={completed}"
    response: Response = requests.get(url, timeout=TIMEOUT_IN_SECONDS)
    response.raise_for_status()
    # for brevity, we'll limit to the first 5 only
    todos = response.json()[:5]
    logger.info("get todos", todos=todos)
    return todos


# Get a specific todo by given todo_id
@router.get("/todos/<todo_id>", tags=["Todo"], summary="Get todo by todo id")
def get_todo_by_id(todo_id: int) -> Todo:
    response: Response = requests.get(
        f"{DEMO_API_URL}/todos/{todo_id}", timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    todo = response.json()
    logger.info(f"get todo with given todo_id {todo_id}", todo=todo)
    return todo


# Create a new todo
@router.post("/todos", tags=["Todo"], summary="Create a new todo item")
def create_todo(todo: Annotated[Todo, Body()]) -> Todo:
    todo_data = todo.model_dump(by_alias=True)
    logger.info("create todo with data", json=todo_data)
    response: Response = requests.post(
        f"{DEMO_API_URL}/todos", json=todo_data, timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    todo = response.json()
    logger.info("todo created successfully", todo=todo)
    return todo
