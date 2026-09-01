from aws_lambda_powertools.event_handler import (
    APIGatewayRestResolver,
)
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext

from app.logging import logger
from app.routers import todo, system, user
from app.settings import Config

# Enable Swagger UI
app = APIGatewayRestResolver(enable_validation=True)
app.enable_swagger(
    version=Config.app_version,
    title="Swagger for Todos/Users API",
    tags=["System", "Todo", "User"],
)

# Inject routers
app.include_router(system.router)
app.include_router(todo.router, prefix="/todos")
app.include_router(user.router, prefix="/users")


# Error handling boundary:
# - Missing routes rely on the framework default 404 response; a custom
#   @app.not_found handler is intentionally not registered.
# - Business errors raised by routers (NotFoundError -> 404, validation
#   errors -> 422) are converted to HTTP responses by APIGatewayRestResolver.
# - Unexpected exceptions are logged once by the resolver and re-raised, so
#   Lambda records the original exception type and traceback.


@logger.inject_lambda_context(
    log_event=True, correlation_id_path=correlation_paths.API_GATEWAY_HTTP
)
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)
