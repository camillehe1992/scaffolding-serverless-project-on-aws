"""Todo router tests covering identity semantics and timestamps."""

# pytest fixtures are often requested for their side effects only
# pylint: disable=unused-argument

import json
import re
from unittest import mock

import pytest

import app.database.models as models_mod
from app.database import TodoModel
from app.main import app

TODO = {
    "id": "todo-1",
    "user_id": "user-1",
    "title": "delectus aut autem",
    "completed": False,
}


def test_list_todos_returns_empty_list(api_event, lambda_context, tables):
    response = app.resolve(api_event("GET", "/todos"), lambda_context)

    assert response["statusCode"] == 200
    assert json.loads(response["body"]) == []


def test_create_todo_sets_server_owned_timestamps(
    api_event, lambda_context, tables, timestamp_pattern
):
    response = app.resolve(api_event("POST", "/todos", body=TODO), lambda_context)

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["id"] == "todo-1"
    assert timestamp_pattern.match(body["created_at"])
    assert timestamp_pattern.match(body["updated_at"])
    assert body["created_at"] == body["updated_at"]
    stored = TodoModel.get("todo-1")
    assert re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z", stored.created_at)
    assert stored.created_at == stored.updated_at


def test_get_todo_resolves_by_primary_key(api_event, lambda_context, tables):
    TodoModel(id="todo-a", user_id="user-1", title="same title", completed=False).save()
    TodoModel(id="todo-b", user_id="user-1", title="same title", completed=False).save()

    response = app.resolve(api_event("GET", "/todos/todo-a"), lambda_context)

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["id"] == "todo-a"
    assert body["title"] == "same title"


def test_get_missing_todo_returns_404(api_event, lambda_context, tables):
    response = app.resolve(api_event("GET", "/todos/missing"), lambda_context)

    assert response["statusCode"] == 404
    assert "missing" in json.loads(response["body"])["message"]


def test_update_todo_uses_id_not_title(api_event, lambda_context, tables):
    TodoModel(id="todo-1", user_id="user-1", title="stored title", completed=False).save()

    response = app.resolve(
        api_event(
            "PUT",
            "/todos/todo-1",
            body={
                "id": "todo-1",
                "user_id": "user-1",
                "title": "different title",
                "completed": True,
            },
        ),
        lambda_context,
    )

    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["id"] == "todo-1"
    assert body["completed"] is True
    assert body["title"] == "stored title"


def test_update_todo_bumps_updated_at(monkeypatch, api_event, lambda_context, tables):
    TodoModel(**TODO).save()
    monkeypatch.setattr(
        "app.routers.todo.utc_now_iso", lambda: "2099-01-02T00:00:00.000Z"
    )

    response = app.resolve(
        api_event("PUT", "/todos/todo-1", body={**TODO, "completed": True}),
        lambda_context,
    )

    body = json.loads(response["body"])
    assert body["updated_at"] == "2099-01-02T00:00:00Z"
    assert body["updated_at"] > body["created_at"]
    assert TodoModel.get("todo-1").updated_at == "2099-01-02T00:00:00.000Z"


def test_delete_todo_uses_id_not_title(api_event, lambda_context, tables):
    TodoModel(id="todo-1", user_id="user-1", title="stored title", completed=False).save()

    response = app.resolve(api_event("DELETE", "/todos/todo-1"), lambda_context)

    assert response["statusCode"] == 200
    with pytest.raises(TodoModel.DoesNotExist):
        TodoModel.get("todo-1")


def test_missing_todo_returns_404_on_update_and_delete(
    api_event, lambda_context, tables
):
    put = app.resolve(
        api_event("PUT", "/todos/missing", body={**TODO, "id": "missing"}),
        lambda_context,
    )
    delete = app.resolve(api_event("DELETE", "/todos/missing"), lambda_context)

    assert put["statusCode"] == 404
    assert delete["statusCode"] == 404


def test_default_timestamps_are_evaluated_at_write_time(
    monkeypatch, api_event, lambda_context, tables
):
    fake_datetime = mock.Mock(wraps=models_mod.datetime)
    fake_datetime.now.return_value = models_mod.datetime(
        2026, 1, 1, tzinfo=models_mod.timezone.utc
    )
    monkeypatch.setattr(models_mod, "datetime", fake_datetime)

    first = app.resolve(
        api_event("POST", "/todos", body={**TODO, "id": "todo-1"}), lambda_context
    )
    fake_datetime.now.return_value = models_mod.datetime(
        2026, 1, 2, tzinfo=models_mod.timezone.utc
    )
    second = app.resolve(
        api_event("POST", "/todos", body={**TODO, "id": "todo-2"}), lambda_context
    )

    assert json.loads(first["body"])["created_at"] == "2026-01-01T00:00:00Z"
    assert json.loads(second["body"])["created_at"] == "2026-01-02T00:00:00Z"
