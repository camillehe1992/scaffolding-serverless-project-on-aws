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
        body={
            "version": os.getenv("APP_VERSION"),
            "service": os.getenv("POWERTOOLS_SERVICE_NAME"),
            "nickname": os.getenv("NICKNAME"),
            "environment": os.getenv("ENVIRONMENT"),
            "deployed_at": os.getenv("DEPLOYED_AT"),
        },
    )
