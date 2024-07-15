import requests
from aws_lambda_powertools.event_handler import Response
from aws_lambda_powertools.event_handler.api_gateway import Router
from aws_lambda_powertools.event_handler.openapi.params import Body
from aws_lambda_powertools.shared.types import Annotated

from ..logging import logger
from ..models import User


# Constants
DEMO_API_URL = "https://jsonplaceholder.typicode.com"
TIMEOUT_IN_SECONDS = 60


router = Router()


# List all users
@router.get(rule="", tags=["User"], summary="Get all users")
def get_users() -> list[User]:
    url = f"{DEMO_API_URL}/users"
    response: Response = requests.get(url, timeout=TIMEOUT_IN_SECONDS)
    response.raise_for_status()
    # for brevity, we'll limit to the first 5 only
    users = response.json()[:5]
    logger.info("get users", users=users)
    return users


# Get a specific user by given user id
@router.get(rule="/<id>", tags=["User"], summary="Get user item by user id")
def get_user_by_id(id: int) -> User:
    response: Response = requests.get(
        f"{DEMO_API_URL}/users/{id}", timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    user = response.json()
    logger.info(f"get user with given user_id {id}", user=user)
    return user


# Create a new user
@router.post(rule="", tags=["User"], summary="Create a new user item")
def create_user(user: Annotated[User, Body()]) -> User:
    user_data = user.model_dump(by_alias=True)
    logger.info("create user with data", json=user_data)
    response: Response = requests.post(
        f"{DEMO_API_URL}/users", json=user_data, timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    user = response.json()
    logger.info("user created successfully", user=user)
    return user


# Delete a new user by user id
@router.delete(rule="/<id>", tags=["User"], summary="Delete a user item by user id")
def delete_user_by_id(id: int) -> User:
    response: Response = requests.delete(
        f"{DEMO_API_URL}/users/{id}", timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    user = response.json()
    logger.info(f"delete user with given id {id}", user=user)
    return user
