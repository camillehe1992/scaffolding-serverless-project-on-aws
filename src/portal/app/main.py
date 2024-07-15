import os
from aws_lambda_powertools.event_handler import (
    APIGatewayRestResolver,
    Response,
    content_types,
)
from aws_lambda_powertools.event_handler.exceptions import NotFoundError
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext

from .logging import logger
from .routers import todo, system, user

# Enable Swagger UI
app = APIGatewayRestResolver(enable_validation=True)
app.enable_swagger(
    version=os.getenv("APP_VERSION"),
    title="Swagger for Todo API",
    tags=["System", "Todo", "User"],
)

# Inject routers
app.include_router(system.router)
app.include_router(todo.router, prefix="/todos")
app.include_router(user.router, prefix="/users")


@app.not_found
def handle_not_found_errors(exc: NotFoundError) -> Response:
    logger.info(f"Not found route: {app.current_event.path}", exc.msg)
    return Response(
        status_code=418,
        content_type=content_types.TEXT_PLAIN,
        body="The route is not found",
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
