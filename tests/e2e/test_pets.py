import json

from frontend.app.main import lambda_handler


def new_pet_payload(payload=None):
    if not payload:
        payload = {}
    return {
        "path": "/pets",
        "httpMethod": "POST",
        "body": json.dumps(payload),
    }


def get_pets_payload():
    return {"path": "/pets", "httpMethod": "GET"}


def test_get_pets_return_200(lambda_context_fixture):
    response = lambda_handler(get_pets_payload(), lambda_context_fixture)
    body = json.loads(response["body"])
    assert len(body["data"]["pets"]) == 3
