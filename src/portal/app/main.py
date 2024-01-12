import requests
from aws_lambda_powertools.event_handler import (
    APIGatewayRestResolver,
    Response,
    content_types,
)
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.event_handler.openapi.exceptions import (
    RequestValidationError,
)

from .logging import logger
from .model import Todo

app = APIGatewayRestResolver(enable_validation=True)

DEMO_API_URL = "https://jsonplaceholder.typicode.com"
TIMEOUT_IN_SECONDS = 60


@app.get("/health", cors=False)  # optionally removes CORS for a given route
def am_i_alive():
    return {"am_i_alive": "yes"}


# List all todos
@app.get("/todos")
def get_todos() -> [Todo]:
    todos: Response = requests.get(f"{DEMO_API_URL}/todos", timeout=TIMEOUT_IN_SECONDS)
    todos.raise_for_status()
    # for brevity, we'll limit to the first 5 only
    todos = {"todos": todos.json()[:5]}
    logger.info("get todos", todos=todos)
    return todos


# Get a specific todo by given todo_id
@app.get("/todos/<todo_id>")
def get_todo_by_id(todo_id: Todo) -> int:  # value come as str
    todos: Response = requests.get(
        f"{DEMO_API_URL}/todos/{todo_id}", timeout=TIMEOUT_IN_SECONDS
    )
    todos.raise_for_status()
    todo = todos.json()
    logger.info(f"get todo with given todo_id {todo_id}", todo=todo)
    return todo["id"]


# Create a new todo
@app.post("/todos")
def create_todo() -> Todo:
    todo_data: dict = app.current_event.json_body  # deserialize json str to dict
    logger.info("create todo with data", data=todo_data)
    todo: Response = requests.post(
        f"{DEMO_API_URL}/todos", data=todo_data, timeout=TIMEOUT_IN_SECONDS
    )
    todo.raise_for_status()
    todo = todo.json()
    logger.info("todo created successfully", todo=todo)
    return todo


# We use exception handler decorator to catch any request validation errors.
# Then, we log the detailed reason as to why it failed while returning a custom Response object to hide that from them.
@app.exception_handler(RequestValidationError)
def handle_validation_error(ex: RequestValidationError):
    logger.error(
        "Request failed validation", path=app.current_event.path, errors=ex.errors()
    )
    return Response(
        status_code=422,
        content_type=content_types.APPLICATION_JSON,
        body="Invalid data",
    )


# You can continue to use other utilities just as before
@logger.inject_lambda_context(
    log_event=True, correlation_id_path=correlation_paths.API_GATEWAY_REST
)
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)
