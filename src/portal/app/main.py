# pylint: disable=consider-alternative-union-syntax
from typing import Optional
import requests
from aws_lambda_powertools.event_handler import (
    APIGatewayRestResolver,
    Response,
    content_types,
)
from aws_lambda_powertools.event_handler.exceptions import NotFoundError
from aws_lambda_powertools.event_handler.openapi.params import Body, Query
from aws_lambda_powertools.shared.types import Annotated
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext
from .logging import logger
from .model import Todo

app = APIGatewayRestResolver(enable_validation=True)
app.enable_swagger(path="/swagger")

DEMO_API_URL = "https://jsonplaceholder.typicode.com"
TIMEOUT_IN_SECONDS = 60


@app.get("/health", cors=False)  # optionally removes CORS for a given route
def am_i_alive():
    return {"am_i_alive": "yes"}


# List all todos
@app.get("/todos")
def get_todos(
    completed: Annotated[Optional[str], Query(min_length=4)] = None
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
@app.get("/todos/<todo_id>")
def get_todo_by_id(todo_id: int) -> Todo:
    response: Response = requests.get(
        f"{DEMO_API_URL}/todos/{todo_id}", timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    todo = response.json()
    logger.info(f"get todo with given todo_id {todo_id}", todo=todo)
    return todo


# Create a new todo
@app.post("/todos")
def create_todo(todo: Annotated[Todo, Body()]) -> int:
    todo_data = todo.model_dump(by_alias=True)
    logger.info("create todo with data", json=todo_data)
    response: Response = requests.post(
        f"{DEMO_API_URL}/todos", json=todo_data, timeout=TIMEOUT_IN_SECONDS
    )
    response.raise_for_status()
    todo = response.json()
    logger.info("todo created successfully", todo=todo)
    return todo["id"]


@app.not_found
def handle_not_found_errors(exc: NotFoundError) -> Response:
    logger.info(f"Not found route: {app.current_event.path}", exc.msg)
    return Response(
        status_code=418, content_type=content_types.TEXT_PLAIN, body="I'm a teapot!"
    )


@logger.inject_lambda_context(
    log_event=True, correlation_id_path=correlation_paths.API_GATEWAY_HTTP
)
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    try:
        return app.resolve(event, context)
    except Exception as err:
        logger.error("Failed to process request", error=err)
        raise Exception(err) from err
