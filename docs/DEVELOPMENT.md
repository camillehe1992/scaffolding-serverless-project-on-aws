# Development Guide

This guide explains how to set up a local development environment for the
serverless Todos/Users API and how to run the common development tasks.

The project has two main parts:

- Python Lambda application code under `src/portal`.
- Terraform/Terragrunt infrastructure under `terraform`.

## Prerequisites

Install the following tools before starting:

- Python 3.12+
- AWS CLI
- Terraform
- Terragrunt
- just
- pre-commit
- terraform-docs
- markdownlint-cli

On macOS, you can install the infrastructure tooling with Homebrew:

```bash
brew install awscli terraform terragrunt just pre-commit terraform-docs markdownlint-cli
```

Configure AWS credentials for the account you plan to use:

```bash
aws configure --profile app-deployer
```

The root `justfile` reads `AWS_PROFILE` from `.env` when present and otherwise
falls back to `app-deployer`.

## Python Environment

Create and activate a virtual environment from the repository root:

```bash
python3.12 -m venv .venv
source .venv/bin/activate
```

Install application and development dependencies:

```bash
pip install -r src/requirements-dev.txt
```

You can also use the `src` justfile:

```bash
cd src
just install
cd ..
```

Production packaging currently installs only `src/requirements.txt` into the
project-managed dependency layer. Development dependencies such as AWS Lambda
Powertools, Pydantic, Boto3, pytest, and coverage are installed locally through
`src/requirements-dev.txt`.

## Environment Variables

The application has defaults for local development, but these variables are the
important ones when you want to override behavior:

```bash
export AWS_REGION=ap-southeast-1
export ENVIRONMENT=dev
export APPLICATION_NAME=slstemplate
export LOG_LEVEL=DEBUG
export POWERTOOLS_LOG_LEVEL=DEBUG
export POWERTOOLS_SERVICE_NAME=slstemplate
```

By default, the application expects these DynamoDB table names:

```bash
dev-slstemplate-users
dev-slstemplate-todos
```

Override them when you are pointing the app at differently named tables:

```bash
export USERS_TABLE_NAME=my-users-table
export TODOS_TABLE_NAME=my-todos-table
```

## Local Lambda Runs

Local API Gateway events live in `src/tests/local/events.json`.

Run the Lambda handler locally from the `src` directory:

```bash
cd src
just local-test get_all_todos
just local-test get_all_users
just local-test create_user
cd ..
```

The local runner imports `app.main.lambda_handler`, builds a mock Lambda
context, and invokes the handler with the selected event.

These local runs still use the configured DynamoDB tables, so make sure your
AWS credentials and table names are correct when testing routes that read or
write data.

## Tests

Run unit tests from the `src` directory:

```bash
cd src
just unit-test
cd ..
```

Equivalent direct command:

```bash
cd src
python -m pytest tests/unit/ -v
cd ..
```

Run integration or end-to-end tests when those suites are present and their
external dependencies are available:

```bash
cd src
just integration-test
just e2e-test
cd ..
```

## Linting And Formatting

Enable pre-commit hooks once after cloning:

```bash
pre-commit install
```

Run all configured hooks manually:

```bash
pre-commit run --all-files
```

The configured hooks cover common file checks plus Terraform/Terragrunt
formatting and validation. You can also run the infrastructure formatting
helpers directly:

```bash
just hcl-fmt
just hcl-validate
```

Run Python linting from `src`:

```bash
cd src
pylint portal tests
cd ..
```

## Build Lambda Dependency Layer

Before planning or applying the API unit, build the Lambda dependency layer zip:

```bash
just deps-zip
```

This creates:

```text
.build/dependencies.zip
```

The API Terraform unit reads that zip when creating the project-managed Lambda
layer.

## Infrastructure Development

The active Terragrunt environments are:

- `terraform/environments/dev`
- `terraform/environments/prod`

The active units are:

- `security`
- `dynamodb`
- `api`

For local development, use `dev`.

Check AWS credentials:

```bash
just pre-check dev security
```

Plan and apply individual units:

```bash
just plan dev security
just apply dev security

just plan dev dynamodb
just apply dev dynamodb

just deps-zip
just plan dev api
just apply dev api
```

Plan and apply the full environment:

```bash
just plan-all dev
just apply-all dev
```

Show Terraform outputs:

```bash
just output dev api
just output-all dev
```

Destroy development infrastructure when finished:

```bash
just destroy dev api
just destroy dev dynamodb
just destroy dev security
```

Avoid using `prod` for local development.

## Seed Data

Sample data lives in:

- `data/users.json`
- `data/todos.json`

Import sample data into the default development DynamoDB tables:

```bash
just import-ddb
```

The import script clears the target tables before importing. Review
`data/import_to_dynamodb.py` before running it against any shared environment.

## Common Workflow

For a normal local development loop:

```bash
source .venv/bin/activate
pip install -r src/requirements-dev.txt

cd src
just unit-test
just local-test get_all_todos
cd ..

just deps-zip
just plan dev api
```

When infrastructure changes are involved, validate the Terragrunt configuration
and run a plan before applying:

```bash
just hcl-fmt
just hcl-validate
just plan dev api
```

## Troubleshooting

If Python imports fail locally, confirm the virtual environment is active and
dependencies were installed from `src/requirements-dev.txt`.

If local Lambda runs cannot access DynamoDB, confirm:

- Your AWS profile is configured.
- `AWS_REGION` matches the table region.
- `USERS_TABLE_NAME` and `TODOS_TABLE_NAME` point to existing tables.

If API planning fails because the dependency layer zip is missing, run:

```bash
just deps-zip
```

If Terragrunt state or provider cache gets stale, clean local generated files:

```bash
just clean
```
