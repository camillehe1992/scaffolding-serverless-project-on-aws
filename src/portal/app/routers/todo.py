from typing import Optional
from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.openapi.params import Body, Query
from aws_lambda_powertools.shared.types import Annotated
from aws_lambda_powertools.event_handler.exceptions import NotFoundError

from ..logging import logger
from ..models import Todo
from ..database import TodoModel, return_pagination_result

router = Router()


@router.get(rule="", tags=["Todo"], summary="Get all todos")
def get_todos(
    completed: Annotated[
        Optional[str],
        Query(
            min_length=4,
            description="Whether the todo is completed or not. true or false",
        ),
    ] = None
) -> list[Todo]:
    if completed is not None:
        response = TodoModel.scan(
            filter_condition=TodoModel.completed
            == (completed in set("True", "true", True)),
        )
    else:
        response = TodoModel.scan()
    todos = return_pagination_result(response)
    logger.info("Get todos", todos=todos)
    return todos


@router.get(rule="/<id>", tags=["Todo"], summary="Get todo by id")
def get_todo_by_id(id: str) -> Todo:
    try:
        response = TodoModel.query(id)
        todos = return_pagination_result(response)
        logger.info(f"Retrieved todo {id}", user=todos[0])
        return todos[0]
    except TodoModel.DoesNotExist as exc:
        logger.error(f"Todo {id} does not exist", exc_info=exc)
        raise NotFoundError(f"Todo {id} does not exist")


@router.post(rule="", tags=["Todo"], summary="Create a new todo")
def create_todo(todo: Annotated[Todo, Body()]) -> Todo:
    # Only support in pydantic v1
    todo_data = todo.dict(by_alias=True)
    logger.info("Create todo with data", json=todo_data)
    new_todo = TodoModel(**todo_data)
    response = new_todo.save()
    logger.info(f"Todo {new_todo.id} is created successfully", response=response)
    return new_todo.attribute_values


@router.put(rule="/<id>", tags=["Todo"], summary="Update a todo item")
def update_todo(id: str, todo: Annotated[Todo, Body()]) -> Todo:
    # Only support in pydantic v1
    todo_data = todo.dict(by_alias=True)
    logger.info(f"Update todo {id} with data", todo_data=todo_data)
    try:
        current_todo = TodoModel(id, todo_data.get("title"))
        response = current_todo.update(
            actions=[
                TodoModel.completed.set(todo_data.get("completed")),
            ]
        )
        logger.info(
            f"Todo {current_todo.id} is updated successfully", response=response
        )
        return current_todo.attribute_values
    except TodoModel.DoesNotExist as exc:
        logger.error("Todo does not exist", todo_data=todo_data, exc_info=exc)
        raise NotFoundError("Todo does not exist")


@router.delete(rule="/<id>", tags=["Todo"], summary="Delete a todo by id")
def delete_todo_by_id(id: str) -> dict:
    try:
        response = TodoModel.query(id)
        todos = return_pagination_result(response)
        todo = TodoModel(id, todos[0]["title"])
        response = todo.delete()
        logger.info(f"Todo {todo.id} is deleted successfully", response=response)
        return {"message": f"Todo {todo.id} is deleted successfully"}
    except TodoModel.DoesNotExist:
        logger.error("Todo does not exist", todo_data=todo)
        raise NotFoundError("Todo does not exist")
