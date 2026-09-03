# Local Python Development Environment Setup

This document covers the Python application under `src/portal`, its tests under
`src/tests`, and the local commands defined in `src/justfile`.

## Install Python

- Install Python 3.14+ from <https://www.python.org/downloads/mac-osx/>.

## Create A Virtual Environment

From the repository root:

```bash
python3.14 -m venv .venv
source .venv/bin/activate
pip install -r src/requirements-dev.txt
```

You can install the same dependencies through the `src` justfile:

```bash
cd src
just install
cd ..
```

## Local Lambda Runs

Local API Gateway events live in `src/tests/local/events.json`.

Run them from the `src` directory:

```bash
cd src
just local-test get_all_todos
just local-test get_all_users
just local-test create_user
cd ..
```

These commands invoke `tests.local.run`, not `python-lambda-local`.

## Tests

Run unit tests from `src`:

```bash
cd src
just unit-test
cd ..
```

Integration and end-to-end recipes are available, but they skip cleanly when
there are no matching test files:

```bash
cd src
just integration-test
just e2e-test
cd ..
```

## Linting And Formatting

Run the same Python lint command used by CI from `src`:

```bash
cd src
pylint portal/app tests/unit tests/conftest.py
cd ..
```

Run all configured pre-commit hooks from the repository root:

```bash
pre-commit run --all-files
```

## Notes

- Root-level infrastructure and workflow guidance lives in [docs/DEVELOPMENT.md](../docs/DEVELOPMENT.md) and [terraform/README.md](../terraform/README.md).
- Deactivate the virtual environment with `deactivate` when you are done.
