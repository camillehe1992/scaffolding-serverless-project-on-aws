"""Lambda entrypoint and HTTP boundary behavior."""

import pytest

from app.main import app, lambda_handler


def test_unknown_route_returns_framework_default_404(api_event, lambda_context):
    response = lambda_handler(api_event("GET", "/does-not-exist"), lambda_context)

    assert response["statusCode"] == 404


def test_invalid_request_body_returns_422(api_event, lambda_context):
    response = lambda_handler(
        api_event("POST", "/todos", body={"id": "todo-1"}), lambda_context
    )

    assert response["statusCode"] == 422


def test_unexpected_exception_propagates_with_original_type(
    monkeypatch, api_event, lambda_context
):
    def boom(event, context):
        raise ValueError("boom")

    monkeypatch.setattr(app, "resolve", boom)

    with pytest.raises(ValueError, match="boom"):
        lambda_handler(api_event("GET", "/todos"), lambda_context)
