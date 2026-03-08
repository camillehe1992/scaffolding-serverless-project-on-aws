from datetime import datetime
from datetime import timezone
from typing import List
from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.openapi.params import Body
from aws_lambda_powertools.event_handler.exceptions import NotFoundError
from typing_extensions import Annotated

from app.database import UserModel, return_pagination_result
from app.logging import logger
from app.models.user import User, UserCreated, UserUpdated

router = Router()


@router.get(rule="", tags=["User"], summary="Get all users")
def get_users() -> List[User]:
    response = UserModel.scan()
    users = return_pagination_result(response)
    logger.info(f"Get users, count={len(users)}", users=users)
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
def create_user(user: UserCreated) -> User:
    user_data = user.model_dump(by_alias=True)
    logger.info(f"Create user with data {user_data.get('email')}", json=user_data)
    new_user = UserModel(**user_data)
    try:
        response = new_user.save()
    except Exception as exc:
        logger.error(f"Error creating user {user_data.get('email')}", exc_info=exc)
        raise exc
    # get newly created user from db
    response = UserModel.query(new_user.id)
    users = return_pagination_result(response)
    logger.info(f"User {new_user.id} is created successfully", new_user=users[0])
    return users[0]


@router.put(rule="/<id>", tags=["User"], summary="Update a user item")
def update_user(id: str, user: UserUpdated) -> User:
    try:
        # Check user exists
        response = UserModel.query(id)
        users = return_pagination_result(response)
        current_user = UserModel(id, users[0]["email"])
        if not current_user.exists():
            logger.error(f"User {id} does not exist")
            raise NotFoundError(f"User {id} does not exist")
        logger.info(f"Found user {id}", user=current_user)

        # Update user
        user_data = user.model_dump(by_alias=True)
        logger.info(f"Update user {id} with data", user_data=user_data)
        current_user = UserModel(id, user_data.get("email"))
        response = current_user.update(
            actions=[
                UserModel.name.set(user_data.get("name")),
                UserModel.phone.set(user_data.get("phone")),
                UserModel.website.set(user_data.get("website")),
                UserModel.company.set(user_data.get("company")),
                UserModel.updated_at.set(
                    datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")
                ),
            ]
        )
        logger.info(f"User {id} is updated successfully", response=response)
        return current_user.attribute_values
    except UserModel.DoesNotExist as exc:
        logger.error(f"User {id} does not exist", user_data=user_data, exc_info=exc)
        raise NotFoundError(f"User {id} does not exist")
    except Exception as exc:
        logger.error(f"Error updating user {id}", user_data=user_data, exc_info=exc)
        raise exc


@router.delete(rule="/<id>", tags=["User"], summary="Delete a user by id")
def delete_user_by_id(id: str) -> dict:
    try:
        # Check user exists
        response = UserModel.query(id)
        users = return_pagination_result(response)
        if not users:
            logger.error(f"User {id} does not exist")
            raise NotFoundError(f"User {id} does not exist")

        # Delete user
        user = UserModel(id)
        logger.info(f"Found user {id}", user=user)
        response = user.delete()
        logger.info(f"User {id} is deleted successfully", response=response)
        return {"message": f"User {id} is deleted successfully"}
    except UserModel.DoesNotExist:
        logger.error(f"User {id} does not exist", user_data=user)
        raise NotFoundError(f"User {id} does not exist")
    except Exception as exc:
        logger.error(f"Error deleting user {id}", exc_info=exc)
        raise exc
