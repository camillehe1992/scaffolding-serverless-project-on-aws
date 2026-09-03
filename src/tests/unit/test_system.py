"""System router tests."""

import json
import re

from app.main import app
from app.settings import format_app_version


def test_health_returns_200(api_event, lambda_context):
    response = app.resolve(api_event("GET", "/health"), lambda_context)

    assert response["statusCode"] == 200
    assert response["body"] == "SERVER IS UP"


def test_system_info_returns_application_metadata(api_event, lambda_context):
    response = app.resolve(api_event("GET", "/system-info"), lambda_context)

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert re.fullmatch(r"0\.0\.1\.dev\.\d+", body["version"])
    assert body["service"] == "sls-template"
    assert body["application_name"] == "sls-template"
    assert body["environment"] == "dev"
    assert body["current_datetime"]


def test_format_app_version_adds_environment_for_non_prod_and_omits_for_prod():
    assert format_app_version("0.0.1", "dev", 1234236309) == "0.0.1.dev.1234236309"
    assert format_app_version("0.0.1", "prod", 1234236309) == "0.0.1.1234236309"
