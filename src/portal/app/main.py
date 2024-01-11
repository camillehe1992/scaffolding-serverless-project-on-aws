import requests
from requests import Response

from aws_lambda_powertools import Logger
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()
app = APIGatewayRestResolver()

TIMEOUT_IN_SECONDS = 60


@app.get("/health", cors=False)  # optionally removes CORS for a given route
def am_i_alive():
    return {"am_i_alive": "yes"}


@app.get("/todos")
def get_todos():
    todos: Response = requests.get(
        "https://jsonplaceholder.typicode.com/todos", timeout=TIMEOUT_IN_SECONDS
    )
    todos.raise_for_status()

    # for brevity, we'll limit to the first 10 only
    return {"todos": todos.json()[:10]}


# You can continue to use other utilities just as before
@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)
