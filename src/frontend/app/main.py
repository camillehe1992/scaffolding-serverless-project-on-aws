import json
import requests
from requests import Response
from aws_lambda_powertools.logging import Logger
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.utilities.typing import LambdaContext
from .response import lambda_response

logger = Logger()
app = APIGatewayRestResolver()

MOCK_URL = "http://petstore.execute-api.cn-north-1.amazonaws.com.cn/petstore"
HEADERS = {"Content-Type": "application/json"}
TIMEOUT = 10


@app.get("/pets")
def get_pets():
    pets: Response = requests.get(f"{MOCK_URL}/pets", timeout=TIMEOUT)
    pets.raise_for_status()
    return {"pets": pets.json()[:10]}


@app.post("/pets")
def create_pet():
    pet_data: dict = app.current_event.json_body  # deserialize json str to dict
    pet: Response = requests.post(
        f"{MOCK_URL}/pets", data=json.dumps(pet_data), timeout=TIMEOUT, headers=HEADERS
    )
    pet.raise_for_status()
    return {"pet": pet.json()}


@app.get("/pets/<petId>")
def get_pet_by_id(petId: str):
    pets: Response = requests.get(
        f"{MOCK_URL}/pets/{petId}", timeout=TIMEOUT, headers=HEADERS
    )
    pets.raise_for_status()
    return {"pets": pets.json()}


@app.get("/health", cors=False)  # optionally removes CORS for a given route
def am_i_alive():
    return {"am_i_alive": "yes"}


# The entry of Lambda function
@logger.inject_lambda_context(log_event=True)
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    try:
        response = app.resolve(event, context)
        return lambda_response(response["body"], event["path"])
    except Exception as e:
        logger.exception("Lambda failed with an exception", exc_info=e)
        raise e
