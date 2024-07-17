##################################################################################
# Test Lambda function via below command from project root dir

# >> python -m src.tests.local.run
# or make local-test

##################################################################################

import os
import sys
import json
from lambda_local.main import call
from lambda_local.context import Context

# Add the parent folder path of the folder where the current file is located to PYTHONPATH
# pylint: disable=wrong-import-position
current_dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(current_dir.replace("tests/local", ""))

# Import Lambda portal function
from portal.app.main import lambda_handler

# Import test event
context = Context(timeout_in_seconds=15)
file_path = f"{current_dir}/events.json"
test_case = "update_todo"

if __name__ == "__main__":
    with open(file_path, encoding="utf-8") as my_file:
        event = json.loads(my_file.read()).get(test_case)
        event["body"] = json.dumps(event["body"])
        res = call(lambda_handler, event, context)
        obj = json.loads(res[0]["body"])
        print("------------------ HTTP Response Payload -------------------")
        print(json.dumps(obj, indent=2))
