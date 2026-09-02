"""System router tests."""

import json

from app.main import app


def test_health_returns_200(api_event, lambda_context):
    response = app.resolve(api_event("GET", "/health"), lambda_context)

    assert response["statusCode"] == 200
    assert response["body"] == "SERVER IS UP"


def test_system_info_returns_application_metadata(api_event, lambda_context):
    response = app.resolve(api_event("GET", "/system-info"), lambda_context)

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["application_name"] == "slstemplate"
    assert body["environment"] == "test"
    assert body["current_datetime"]
