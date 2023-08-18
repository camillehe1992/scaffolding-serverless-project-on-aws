import json
from datetime import datetime
from typing import Any
from http import HTTPStatus
from .logging import logger
from .enum import ResponseMessage


def lambda_response(data: Any = None, path: str = None):
    if not data:
        data = {}
    if isinstance(data, str):
        data = json.loads(data)
    traceId = None
    timestamp = int(datetime.timestamp(datetime.now()))
    body = {
        "code": str(HTTPStatus.OK.value),
        "message": ResponseMessage.SUCCESS.value,
        "data": data,
        "path": path,
        "traceId": traceId,
        "timestamp": timestamp,
    }
    logger.debug("Lambda response body", body=body)
    return {
        "statusCode": HTTPStatus.OK,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }


def return_error_message(message: str) -> dict:
    return {
        "statusCode": HTTPStatus.BAD_REQUEST,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"statusCode": HTTPStatus.BAD_REQUEST, "message": message}),
    }
