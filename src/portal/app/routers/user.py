from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.exceptions import NotFoundError

from app.database import UserModel, return_pagination_result, utc_now_iso
from app.logging import logger
from app.models.user import User, UserCreated, UserUpdated

router = Router()


@router.get(rule="", tags=["User"], summary="Get all users")
def get_users() -> list[User]:
    response = UserModel.scan()
    users = return_pagination_result(response)
    logger.info(f"Get users, count={len(users)}", users=users)
    return users


@router.get(rule="/<id>", tags=["User"], summary="Get user by id")
def get_user_by_id(id: str) -> User:
    try:
        user = UserModel.get(id)
        logger.info(f"Retrieved user {id}", user=user.attribute_values)
        return user.attribute_values
    except UserModel.DoesNotExist:
        logger.info(f"User {id} does not exist")
        raise NotFoundError(f"User {id} does not exist")


@router.post(rule="", tags=["User"], summary="Create a new user")
def create_user(user: UserCreated) -> User:
    user_data = user.model_dump(by_alias=True)
    logger.info(f"Create user with data {user_data.get('email')}", json=user_data)
    new_user = UserModel(**user_data)
    new_user.save()

    # get newly created user from db
    created_user = UserModel.get(new_user.id)
    logger.info(
        f"User {new_user.id} is created successfully",
        new_user=created_user.attribute_values,
    )
    return created_user.attribute_values


@router.put(rule="/<id>", tags=["User"], summary="Update a user item")
def update_user(id: str, user: UserUpdated) -> User:
    try:
        current_user = UserModel.get(id)
    except UserModel.DoesNotExist:
        logger.info(f"User {id} does not exist")
        raise NotFoundError(f"User {id} does not exist")
    logger.info(f"Found user {id}", user=current_user.attribute_values)

    # Update user
    user_data = user.model_dump(by_alias=True)
    logger.info(f"Update user {id} with data", user_data=user_data)
    response = current_user.update(
        actions=[
            UserModel.name.set(user_data.get("name")),
            UserModel.phone.set(user_data.get("phone")),
            UserModel.website.set(user_data.get("website")),
            UserModel.company.set(user_data.get("company")),
            UserModel.updated_at.set(utc_now_iso()),
        ]
    )
    logger.info(f"User {id} is updated successfully", response=response)
    return current_user.attribute_values


@router.delete(rule="/<id>", tags=["User"], summary="Delete a user by id")
def delete_user_by_id(id: str) -> dict:
    try:
        user = UserModel.get(id)
    except UserModel.DoesNotExist:
        logger.info(f"User {id} does not exist")
        raise NotFoundError(f"User {id} does not exist")
    logger.info(f"Found user {id}", user=user.attribute_values)
    response = user.delete()
    logger.info(f"User {id} is deleted successfully", response=response)
    return {"message": f"User {id} is deleted successfully"}
