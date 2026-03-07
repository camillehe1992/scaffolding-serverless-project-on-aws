import os
from aws_lambda_powertools.event_handler import (
    Response,
    content_types,
)
from aws_lambda_powertools.event_handler.api_gateway import Router
from ..models import SystemInfo

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
            version=os.getenv("APP_VERSION", "1.0.0").replace("\n", ""),
            service=os.getenv("POWERTOOLS_SERVICE_NAME", "slstemplate"),
            application_name=os.getenv("APPLICATION_NAME", "slstemplate"),
            environment=os.getenv("ENVIRONMENT", "dev"),
        ),
    )
