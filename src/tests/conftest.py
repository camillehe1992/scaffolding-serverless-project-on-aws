"""Shared fixtures for the unit test suite.

Environment variables are set before any application module is imported so
tests are isolated from real AWS accounts and tables.
"""

import json
import os
import re
import sys
from pathlib import Path
from types import SimpleNamespace

import boto3
import moto
import pytest

PORTAL_ROOT = Path(__file__).resolve().parents[1] / "portal"
sys.path.insert(0, str(PORTAL_ROOT))

os.environ["AWS_ACCESS_KEY_ID"] = "testing"
os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
os.environ["AWS_REGION"] = "ap-southeast-1"
os.environ["AWS_DEFAULT_REGION"] = "ap-southeast-1"
os.environ["ENVIRONMENT"] = "dev"
os.environ["APPLICATION_NAME"] = "sls-template"
os.environ["APP_VERSION"] = "0.0.1"
os.environ["TODOS_TABLE_NAME"] = "dev-sls-template-todos"
os.environ["USERS_TABLE_NAME"] = "dev-sls-template-users"

from app.settings import Config  # noqa: E402  # pylint: disable=wrong-import-position


@pytest.fixture(autouse=True)
def aws_mock():
    """Route all AWS calls to moto for every test."""
    with moto.mock_aws():
        boto3.setup_default_session(region_name=Config.aws_region)
        yield


@pytest.fixture
def tables():
    """Create the DynamoDB tables exactly as Terraform defines them."""
    client = boto3.client("dynamodb", region_name=Config.aws_region)
    for table_name in (Config.todos_table_name, Config.users_table_name):
        client.create_table(
            TableName=table_name,
            KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
            AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )
    yield client


@pytest.fixture
def api_event():
    """Build a minimal API Gateway REST event for the resolver."""

    def _build(method: str, path: str, body: dict | None = None) -> dict:
        return {
            "httpMethod": method,
            "path": path,
            "resource": path,
            "headers": {"Content-Type": "application/json"},
            "multiValueHeaders": {},
            "queryStringParameters": None,
            "multiValueQueryStringParameters": None,
            "pathParameters": None,
            "body": json.dumps(body) if body is not None else None,
            "isBase64Encoded": False,
            "requestContext": {
                "requestId": "test-request",
                "apiId": "test-api",
                "stage": "dev",
                "resourcePath": path,
                "httpMethod": method,
                "identity": {"sourceIp": "127.0.0.1"},
            },
        }

    return _build


@pytest.fixture
def lambda_context():
    """Minimal Lambda context for the Powertools decorator."""
    return SimpleNamespace(
        function_name="unit-test",
        function_version="$LATEST",
        invoked_function_arn="arn:aws:lambda:test:123456789012:function:unit-test",
        memory_limit_in_mb=128,
        aws_request_id="test-request-id",
        log_group_name="/aws/lambda/unit-test",
        log_stream_name="2026/01/01/[$LATEST]abc123",
    )


@pytest.fixture
def timestamp_pattern():
    """Compiled regex matching an ISO-8601 UTC timestamp in API responses."""
    return re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z$")
