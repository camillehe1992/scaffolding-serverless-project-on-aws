# A REST API (Serverless) in AWS using Terraform

The project is an AWS cloud native serverless application, including API Gateway, Lambda function (with layers), and Dynamodb for data persistence. However, AWS provides a variety of storage services and you should make the decisition as you needs.

The diagram below shows the archtecture details. All AWS resources are built and deployed using Terraform.

![Cloud Arch Diagram](./docs/images/arch-diagram.png)

## Project Structure

```bash
# tree -La 2
.
├── .coveragerc                 # configuration file for python test coverage
├── .editorconfig               # configuration for editor code style and format
├── .env.sample                 # environment variables for local development and deployment
├── .github
│   └── workflows               # github action workflows
├── .gitignore
├── .pre-commit-config.yaml     # configuration for pre-commit, such as lint, auto format, test
├── .pylintrc                    # configuration for pylint
├── .pytest.ini                  # configuration for pytest
├── .pylintrc
├── Makefile                    # makefile to simplify your local deployment using shell scripts
├── README.md
├── cloudformation              # terraform backend resources CFT
│   └── infra.yaml
├── docs                        # documentation
├── requirements-dev.txt        # thirt-party dependencies for development
├── scripts                     # shell scripts for Jenkins pipelines
├── src
│   ├── __init__.py
│   ├── local_test              # Lambda function test script for local development
│   ├── portal                  # Lambda function portal source code
│   └── tests                   # Lambda source code test, such as unit test, e2e test, etc
└── terraform                   # terraform components and modules definition
    ├── deployment
    ├── modules
    └── settings
```

## Development

Follow [DEPLOYMENT.md](./docs/DEPLOYMENT.md) if you want to contribute on the project.

## Deployment

Follow [DEVELOPMENT.md](./docs/DEVELOPMENT.md) if you want to deploy project from local or via CICD pipelines.

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS Lambda Powertools for Python](https://docs.powertools.aws.dev/lambda/python/latest/)
