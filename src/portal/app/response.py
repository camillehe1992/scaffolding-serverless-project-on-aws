import json
from http import HTTPStatus
from .logging import logger


def lambda_response(body: dict) -> dict:
    if not body:
        body = {}
    if isinstance(body, str):
        body = json.loads(body)
    logger.debug("Lambda response body", body=body)
    return {
        "statusCode": HTTPStatus.OK,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }


def return_error_message(message: str) -> dict:
    logger.error("Lambda response error message", message=message)
    return {
        "statusCode": HTTPStatus.BAD_REQUEST,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"message": message}),
    }
