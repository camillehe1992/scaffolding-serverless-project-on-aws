# A REST API (Serverless) in AWS using Terraform

The project is a AWS cloud native serverless application partially, including API Gateway, Lambda function (with layers), and RDS database for data persistence. _Partially_ here means we use RDS database as data layer for demo purpose instead of a _serverless_ database, like DynamoDB. However, AWS provides a variety of storage services and you should make the decisition as you needs.

The diagram below shows the archtecture details. All AWS resources are built and deployed using Terraform.

![Cloud Arch Diagram](./docs/images/arch-diagram.png)

## Project Structure

```bash
# tree -L 2 -all
.
├── .env.sample
├── .pre-commit-config.yaml     # configuration for pre-commit, such as lint, auto format, test
├── Makefile                    # makefile to simplify your local deployment using shell scripts
├── README.md
├── docs                        # documentation
├── local_invoke.py
├── pylintrc                    # configuration for pylint
├── pytest.ini                  # configuration for pytest
├── requirements-dev.txt
├── scripts                     # shell scripts for Jenkins pipelines
├── src                         # lambda functions, layers, dependencies source code
│   └── portal
├── swagger
│   ├── index.html
│   └── spec.yaml               # swagger specification to define API Gateway methods and paths
├── terraform                   # terraform components and modules definition
│   ├── deployment
│   ├── modules
│   └── settings
└── tests                       # test files and cases, postman collection, unit test, E2E test, etc
```

## Terraform Resources & Modules

| File           | Modules                  | Main AWS Resources                     |
| -------------- | ------------------------ | -------------------------------------- |
| api_gateway.tf | api_gateway              | API Gateway, CloudWatch Logs Group     |
| function.tf    | portal_function          | Lambda Function, CloudWatch Logs Group |
| layers.tf      | dependencies_layer       | Lambda Layer                           |
| roles.tf       | lambda_execution_role    | IAM Role                               |
| roles.tf       | api_gateway_logging_role | IAM Role                               |

## Development

Follow [DEPLOYMENT.md](./docs/DEPLOYMENT.md) if you want to contribute on the project.

## Deployment

### Terraform Init, Plan & Apply

Find more information from [CICD Pipelines Setup](./docs/cicd.md)

## Linting

Pylint is a static code analyser for Python 2 or 3.

Pylint analyses your code without actually running it. It checks for errors, enforces a coding standard, looks for code smells, and can make suggestions about how the code could be refactored.

> To keep code quality, passing lint is mandantry to commit your code using pre-commit.

See <https://pypi.org/project/pylint/> for more information.

Run the command as below to lint your code.

```bash
make lint
```

## Test

For a standard project, you should have test specification setup, such as unit test, e2e test, etc. And `Postman` is a popular tool for local development.

### Postman

Find Postman colllection from [collection.json](./tests/postman/collection.json)

Please keep Postman colllection updated.

### Unit Test

```bash
# Run all unit test cases in /tests/unit folder
make test.unit

# Run unit test cases in a sepcific file
python -m pytest ./tests/unit/test_main.py
```

### E2E Test

```bash
# Run all e2e test cases in /tests/unit folder
make test.unit

# Run e2e test cases in a sepcific file
python -m pytest ./tests/e2e/test_pets.py
```

Run all test cases using command `make test`.

## Reference

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS Lambda Powertools for Python](https://awslabs.github.io/aws-lambda-powertools-python/2.12.0/)
