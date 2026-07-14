# Local Python Development Environment Setup

This document describes how to set up a local development environment for this serverless based python project hosted in Lambda function.

## Install Python on Local Machine

- Install Python 3.12+ following <https://www.python.org/downloads/mac-osx/>.

## Create Virtual Environment & Install Dependencies

From root folder of the project, run below commands to create virtual environment and install dependencies.

```bash

# Create virtual environment (Python 3.12+) in local .venv folder
python3.12 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Your prompt should change to show (.venv)
# (.venv) user@Mac src %

# Install dependencies using pip3.12 in the virtual environment,
# and the dependencies will be installed in the virtual environment
pip install -r src/requirements-dev.txt
# or run just recipe from root directory
just install

# Exit the virtual environment if needed
deactivate
```

Now, you should have `.venv` folder in the project root folder with all dependencies installed.

## Testing

### Local Lambda Test

Run lambda function in python on local machine using [python-lambda-local](https://pypi.org/project/python-lambda-local/). All local test files locates in `src/tests/local` folder.

```bash
# Test GET /todos with event defined in src/local_test/events folder
# Run below recipe from src folder
just local-test get_all_todos
# or just src.local-test get_all_todos from root directory

just local-test post_todo
```

### Unit Test

Run `just unit-test` to execute unit test in one command. All unit test files locates in `src/tests/unit` folder.

```bash
just unit-test
```

### Integration Test

Run `just integration-test` to execute integration test in one command. All integration test files locates in `src/tests/integration` folder.

```bash
just integration-test
```

### E2E Test

Run `just e2e-test` to execute e2e test in one command. All e2e test files locates in `src/tests/e2e` folder.

```bash
just e2e-test
```

### EchoAPI

EchoAPI is a simple API that returns the request body. It is used to test the E2E test.

EchoAPI is deployed in AWS Lambda function, and the API endpoint is `https://<API_ID>.execute-api.<AWS_REGION>.amazonaws.com/v1/echo`.

Replace `<API_ID>` with your actual API ID, `<AWS_REGION>` with your actual AWS region.

## Linting & Formatting

[Pylint](https://pypi.org/project/pylint/) is a static code analyser for Python 2 or 3.

Pylint analyses your code without actually running it. It checks for errors, enforces a coding standard, looks for code smells, and can make suggestions about how the code could be refactored.

__To keep code quality, passing lint is mandantry to commit your code with pre-commit hooks enabled.__

Run `pylint src/*` to lint your python code as a pre check before commiting. Besides, we also enabled terraform code lint and format in pre-commit hooks, so you have to pass terraform lint as well before commiting. Run below to commands to lint and format your terraform code.

```bash
terraform fmt -check -diff -recursive
terraform validate
# or
make lint
```

[TFLint](https://github.com/terraform-linters/tflint) is not a terraform built-in feature, you need to install the tool on your local machine if you want to pre-lint terraform code before commiting.

---

Now, the local development environment is setup.
