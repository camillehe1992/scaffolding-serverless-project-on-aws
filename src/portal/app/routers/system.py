from aws_lambda_powertools.event_handler import Response, content_types
from aws_lambda_powertools.event_handler.api_gateway import Router
from app.models import SystemInfo
from app.settings import Config

router = Router()


@router.get("/health", tags=["System"], summary="Get application health status")
def health() -> str:
    return Response(
        status_code=200, content_type=content_types.TEXT_PLAIN, body="SERVER IS UP"
    )


@router.get(
    "/system-info",
    tags=["System"],
    summary="Get application system information details",
)
def system_info() -> SystemInfo:
    return Response(
        status_code=200,
        content_type=content_types.APPLICATION_JSON,
        body=SystemInfo(
            version=Config.app_version,
            service=Config.powertools_service_name,
            application_name=Config.application_name,
            environment=Config.environment,
        ),
    )
