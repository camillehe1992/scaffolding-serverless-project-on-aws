from typing import Optional
from typing_extensions import Annotated
from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.openapi.params import Body
from aws_lambda_powertools.event_handler.exceptions import NotFoundError

from app.database import TodoModel, return_pagination_result, utc_now_iso
from app.enum import BooleanStr
from app.logging import logger
from app.models import Todo

router = Router()


@router.get(rule="", tags=["Todo"], summary="Get all todos")
def get_todos(completed: Optional[BooleanStr] = None) -> list[Todo]:
    if completed is not None:
        response = TodoModel.scan(
            filter_condition=TodoModel.completed == (completed == BooleanStr.TRUE),
        )
    else:
        response = TodoModel.scan()
    todos = return_pagination_result(response)
    logger.info(f"Get todos, count: {len(todos)}", todos=todos)
    return todos


@router.get(rule="/<id>", tags=["Todo"], summary="Get todo by id")
def get_todo_by_id(id: str) -> Todo:
    try:
        todo = TodoModel.get(id)
        logger.info(f"Retrieved todo {id}", todo=todo.attribute_values)
        return todo.attribute_values
    except TodoModel.DoesNotExist:
        logger.info(f"Todo {id} does not exist")
        raise NotFoundError(f"Todo {id} does not exist")


@router.post(rule="", tags=["Todo"], summary="Create a new todo")
def create_todo(todo: Annotated[Todo, Body()]) -> Todo:
    todo_data = todo.model_dump(by_alias=True)
    # Timestamps are owned by the server and generated at write time
    todo_data.pop("created_at", None)
    todo_data.pop("updated_at", None)
    logger.info("Create todo with data", json=todo_data)
    new_todo = TodoModel(**todo_data)
    response = new_todo.save()
    logger.info(f"Todo {new_todo.id} is created successfully", response=response)
    return new_todo.attribute_values


@router.put(rule="/<id>", tags=["Todo"], summary="Update a todo item")
def update_todo(id: str, todo: Annotated[Todo, Body()]) -> Todo:
    todo_data = todo.model_dump(by_alias=True)
    logger.info(f"Update todo {id} with data", todo_data=todo_data)
    try:
        current_todo = TodoModel.get(id)
        response = current_todo.update(
            actions=[
                TodoModel.completed.set(todo_data.get("completed")),
                TodoModel.updated_at.set(utc_now_iso()),
            ]
        )
        logger.info(
            f"Todo {current_todo.id} is updated successfully", response=response
        )
        return current_todo.attribute_values
    except TodoModel.DoesNotExist:
        logger.info(f"Todo {id} does not exist", todo_data=todo_data)
        raise NotFoundError(f"Todo {id} does not exist")


@router.delete(rule="/<id>", tags=["Todo"], summary="Delete a todo by id")
def delete_todo_by_id(id: str) -> dict:
    try:
        todo = TodoModel.get(id)
        response = todo.delete()
        logger.info(f"Todo {todo.id} is deleted successfully", response=response)
        return {"message": f"Todo {todo.id} is deleted successfully"}
    except TodoModel.DoesNotExist:
        logger.info(f"Todo {id} does not exist")
        raise NotFoundError(f"Todo {id} does not exist")
