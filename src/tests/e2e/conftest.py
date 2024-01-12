import pytest
from aws_lambda_powertools.utilities.typing import LambdaContext


# Define shared fixture here
@pytest.fixture
def lambda_context_fixture():
    context = LambdaContext()
    context._function_name = "test"
    context._memory_limit_in_mb = "test"
    context._invoked_function_arn = "test"
    context._aws_request_id = "test"
    return context
