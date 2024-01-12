##################################################################################
# Test Lambda function via below command from project root dir

# >> python -m src.local_test.local_get_todos

##################################################################################

import os
import sys
import json
from lambda_local.main import call
from lambda_local.context import Context

# Add the parent folder path of the folder where the current file is located to PYTHONPATH
# pylint: disable=wrong-import-position
current_dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(current_dir.replace("local_test", ""))

# Import Lambda portal function
from portal.app.main import lambda_handler

# Define the event input for testing
file_path = f"{current_dir}/events/get_todos.json"
context = Context(timeout_in_seconds=15)

if __name__ == "__main__":
    with open(file_path, encoding="utf-8") as my_file:
        event = json.loads(my_file.read())
        call(lambda_handler, event, context)
