#!/usr/bin/env python3
"""
Local Lambda runner using lambda-local package.
Install: pip install lambda-local
Usage:
    python -m src.tests.local.run [event_name]
    or run
    just local-test EVENT_NAME
"""

import sys
import os
from pathlib import Path

# Add project root to path so imports work
PROJECT_ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(PROJECT_ROOT))

# Add src/portal to path so 'app' imports work
PORTAL_ROOT = PROJECT_ROOT / "src" / "portal"
sys.path.insert(0, str(PORTAL_ROOT))

# Set minimal env vars for local run
os.environ.setdefault("AWS_REGION", "ap-southeast-1")
os.environ.setdefault("ENVIRONMENT", "dev")
os.environ.setdefault("APPLICATION_NAME", "slstemplate")
os.environ.setdefault("LOG_LEVEL", "DEBUG")


# Simple local runner without lambda-local dependency
def run_lambda_local(event_name: str = "get_all_todos"):
    """Run the Lambda handler locally with a test event"""
    import json
    from app.main import lambda_handler
    from app.logging import logger

    # Load test event
    events_file = Path(__file__).with_name("events.json")
    with events_file.open() as f:
        events = json.load(f)

    if event_name not in events:
        print(f"Available events: {list(events.keys())}")
        raise KeyError(event_name)

    event = events[event_name]
    print(f"Running Lambda locally with event: {event_name}")
    print("Event:", json.dumps(event, indent=2))
    if event.get("body", {}):
        event["body"] = json.dumps(event["body"])

    # Create mock Lambda context
    class MockContext:
        def __init__(self):
            self.function_name = "local-test"
            self.function_version = "$LATEST"
            self.invoked_function_arn = (
                "arn:aws:lambda:local:123456789012:function:local-test"
            )
            self.memory_limit_in_mb = 128
            self.remaining_time_in_millis = lambda: 30000
            self.log_group_name = "/aws/lambda/local-test"
            self.log_stream_name = "2023/01/01/[$LATEST]abcd1234"
            self.aws_request_id = "local-request-id"

    context = MockContext()

    try:
        # Run the handler
        result = lambda_handler(event, context)
        print("Lambda result:")
        print(json.dumps(result, indent=2))
        return 0
    except Exception as e:
        logger.error("Lambda execution failed", error=str(e))
        print(f"Error: {e}")
        return 1


def main():
    """Run the Lambda locally with a test event"""
    event_name = sys.argv[1] if len(sys.argv) > 1 else "get_all_todos"
    print(f"Running local test with event: {event_name}")
    return run_lambda_local(event_name)


if __name__ == "__main__":
    sys.exit(main())
