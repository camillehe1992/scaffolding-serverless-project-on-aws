# Local Python Development Environment Setup

This document describes how to set up a local development environment for this serverless based python project hosted in Lambda function.

## Install Python on Local Machine

- Install Python 3.14+ following <https://www.python.org/downloads/mac-osx/>.

## Create Virtual Environment & Install Dependencies

From root folder of the project, run below commands to create virtual environment and install dependencies.

```bash

# Create virtual environment (Python 3.14+) in local .venv folder
python3.14 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Your prompt should change to show (.venv)
# (.venv) user@Mac src %

# Install dependencies using pip in the virtual environment,
# and the dependencies will be installed in the virtual environment
pip install -r src/requirements-dev.txt
# or run the src just recipe
cd src
just install
cd ..

# Exit the virtual environment if needed
deactivate
```

Now, you should have `.venv` folder in the project root folder with all dependencies installed.

## Testing

### Local Lambda Test

Run lambda function in python on local machine using [python-lambda-local](https://pypi.org/project/python-lambda-local/). All local test files locates in `src/tests/local` folder.

```bash
# Test GET /todos with an event defined in src/tests/local/events.json
# Run below recipes from src folder
cd src
just local-test get_all_todos

just local-test create_todo
cd ..
```

### Unit Test

Run `just unit-test` from the `src` directory to execute unit tests in one
command. All unit test files locates in `src/tests/unit` folder.

```bash
cd src
just unit-test
cd ..
```

### Integration Test

Run `just integration-test` from the `src` directory to execute integration
tests in one command. All integration test files locates in
`src/tests/integration` folder.

```bash
cd src
just integration-test
cd ..
```

## Linting & Formatting

[Pylint](https://pypi.org/project/pylint/) is a static code analyser for Python 2 or 3.

Pylint analyses your code without actually running it. It checks for errors, enforces a coding standard, looks for code smells, and can make suggestions about how the code could be refactored.

__To keep code quality, passing lint is mandatory to commit your code with pre-commit hooks enabled.__

From the `src` directory, run the same Python lint command used by CI and
pre-commit:

```bash
cd src
pylint portal/app tests/unit tests/conftest.py
cd ..
```

Terraform and Terragrunt hooks are also part of pre-commit. Run all configured
hooks manually:

```bash
pre-commit run --all-files
```

[TFLint](https://github.com/terraform-linters/tflint) is not a terraform built-in feature, you need to install the tool on your local machine if you want to pre-lint terraform code before commiting.

---

Now, the local development environment is setup.
