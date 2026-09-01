"""User router tests."""

# pytest fixtures are often requested for their side effects only
# pylint: disable=unused-argument

import json

from app.database import UserModel
from app.main import app

USER = {"email": "Sincere@april.biz", "name": "Leanne Graham"}
UPDATE_BODY = {
    "name": "Leanne New",
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
        "name": "Romaguera-Crona",
        "catchPhrase": "Multi-layered client-server neural-net",
        "bs": "harness real-time e-markets",
    },
}


def test_list_users_returns_empty_list(api_event, lambda_context, tables):
    response = app.resolve(api_event("GET", "/users"), lambda_context)

    assert response["statusCode"] == 200
    assert json.loads(response["body"]) == []


def test_create_user_sets_server_owned_timestamps(
    api_event, lambda_context, tables, timestamp_pattern
):
    response = app.resolve(api_event("POST", "/users", body=USER), lambda_context)

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["email"] == USER["email"]
    assert timestamp_pattern.match(body["created_at"])
    assert timestamp_pattern.match(body["updated_at"])


def test_get_user_by_id(api_event, lambda_context, tables):
    UserModel(id="user-1", email=USER["email"], name=USER["name"]).save()

    response = app.resolve(api_event("GET", "/users/user-1"), lambda_context)

    assert response["statusCode"] == 200
    assert json.loads(response["body"])["id"] == "user-1"


def test_get_missing_user_returns_404(api_event, lambda_context, tables):
    response = app.resolve(api_event("GET", "/users/missing"), lambda_context)

    assert response["statusCode"] == 404
    assert "missing" in json.loads(response["body"])["message"]


def test_update_user_bumps_updated_at_and_missing_returns_404(
    monkeypatch, api_event, lambda_context, tables
):
    UserModel(id="user-1", email=USER["email"], name=USER["name"]).save()
    monkeypatch.setattr(
        "app.routers.user.utc_now_iso", lambda: "2099-01-02T00:00:00.000Z"
    )

    response = app.resolve(api_event("PUT", "/users/user-1", body=UPDATE_BODY), lambda_context)

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["name"] == "Leanne New"
    assert body["updated_at"] == "2099-01-02T00:00:00Z"

    missing = app.resolve(api_event("PUT", "/users/missing", body=UPDATE_BODY), lambda_context)
    assert missing["statusCode"] == 404


def test_delete_user_and_missing_user_returns_404(api_event, lambda_context, tables):
    UserModel(id="user-1", email=USER["email"], name=USER["name"]).save()

    response = app.resolve(api_event("DELETE", "/users/user-1"), lambda_context)

    assert response["statusCode"] == 200
    assert not list(UserModel.query("user-1"))

    missing = app.resolve(api_event("DELETE", "/users/missing"), lambda_context)
    assert missing["statusCode"] == 404
