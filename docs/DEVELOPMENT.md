# Local Python Development Environment Setup

This document describes how to set up a local development environment for this serverless based python project hosted in Lambda function.

## Install Python on Local Machine

- Install Python 3.12 following <https://www.python.org/downloads/mac-osx/>.

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

# Exit the virtual environment if needed
deactivate
```

Now, you should have `.venv` folder in the project root folder with all dependencies installed.

## Testing

### Local Lambda Test

Run lambda function in python on local machine using [python-lambda-local](https://pypi.org/project/python-lambda-local/). All local test files locates in `src/local_test` folder.

```bash
# Test GET /todos with event defined in src/local_test/events folder
python -m src.tests.local.run
```

### Unit Test

In the project, we use `pytest` and `unittest` for unit test.

```bash
# Run all unit test cases in /src/tests/unit folder
coverage run -m pytest ./src/tests/unit/

# Run unit test cases in a sepcific file
python -m pytest ./src/tests/unit/test_main.py

# Report unit test coverage
coverage report -m
```

Run `make unit-test` to execute unit test in one command.

### E2E Test

[Tavern](https://pypi.org/project/tavern/) is a pytest plugin, command-line tool and Python library for automated testing of APIs, with a simple, concise and flexible YAML-based syntax.

```bash
# Run all e2e test cases in /tests/unit folder
python -m pytest ./src/tests/e2e/

# Run e2e test cases in a sepcific file
python -m pytest ./src/tests/e2e/test_minimal.tavern.yaml -v
```

### Postman

Find Postman colllection from [collection.json](./src/tests/postman/collection.json)

> Please keep Postman colllection updated.

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
