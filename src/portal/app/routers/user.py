from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.openapi.params import Body
from aws_lambda_powertools.shared.types import Annotated
from aws_lambda_powertools.event_handler.exceptions import NotFoundError

from ..logging import logger
from ..models import User
from ..database import UserModel, return_pagination_result


router = Router()


@router.get(rule="", tags=["User"], summary="Get all users")
def get_users() -> list[User]:
    response = UserModel.scan()
    users = return_pagination_result(response)
    logger.info("Get users", users=users)
    return users


@router.get(rule="/<id>", tags=["User"], summary="Get user by id")
def get_user_by_id(id: str) -> User:
    try:
        response = UserModel.query(id)
        users = return_pagination_result(response)
        logger.info(f"Retrieved user {id}", user=users[0])
        return users[0]
    except UserModel.DoesNotExist as exc:
        logger.error(f"User {id} does not exist", exc_info=exc)
        raise NotFoundError(f"User {id} does not exist")


@router.post(rule="", tags=["User"], summary="Create a new user")
def create_user(user: Annotated[User, Body()]) -> User:
    # Only support in pydantic v1
    user_data = user.dict(by_alias=True)
    logger.info("Create user with data", json=user_data)
    new_user = UserModel(**user_data)
    response = new_user.save()
    logger.info("User is created successfully", response=response)
    return {"message": "User is created successfully"}


@router.put(rule="/<id>", tags=["User"], summary="Update a user item")
def update_user(id: str, user: Annotated[User, Body()]) -> User:
    # Only support in pydantic v1
    user_data = user.dict(by_alias=True)
    logger.info(f"Update user {id} with data", user_data=user_data)
    try:
        user = UserModel(id, user_data.get("email"))
        response = user.update(
            actions=[
                UserModel.username.set(user_data.get("username")),
            ]
        )
        logger.info(f"User {user.id} is updated successfully", response=response)
        return user
    except UserModel.DoesNotExist as exc:
        logger.error("User does not exist", user_data=user_data, exc_info=exc)
        raise NotFoundError("User does not exist")


@router.delete(rule="/<id>", tags=["User"], summary="Delete a user by id")
def delete_user_by_id(id: str) -> User:
    user = UserModel(id)
    response = user.delete()
    logger.info(f"User {id} is deleted successfully", response=response)
    return {"message": "User is deleted successfully"}
