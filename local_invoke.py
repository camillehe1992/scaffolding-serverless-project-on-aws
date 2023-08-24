# pylint: disable=wrong-import-position
# pylint: disable=unused-import
# pylint: disable=wrong-import-order
import json
import os
import sys
from dotenv import load_dotenv

real_path = os.path.dirname(os.path.realpath(__file__))
sys.path.append(real_path + "/src/frontend")

load_dotenv(override=True)
from aws_lambda_powertools.utilities.typing import LambdaContext
from src.frontend.app import main


def get_mock_lambda_context():
    context = LambdaContext()
    context._function_name = "test"
    context._memory_limit_in_mb = "test"
    context._invoked_function_arn = "test"
    context._aws_request_id = "test"
    return context


def test_frontend_lambda_function(path) -> dict:
    with open(path, encoding="utf-8") as my_file:
        response = main.lambda_handler(
            json.loads(my_file.read()), get_mock_lambda_context()
        )
        return json.loads(response["body"])


if __name__ == "__main__":
    args = sys.argv[1:]
    file = args[0]
    result = test_frontend_lambda_function(file)
    print(json.dumps(result, indent=2))
