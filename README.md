# A REST API (Serverless) in AWS using Terraform

The project is a AWS cloud native serverless application partially, including API Gateway, Lambda function (with layers), and RDS database for data persistence. _Partially_ here means we use RDS database as data layer for demo purpose instead of a _serverless_ database, like DynamoDB. However, AWS provides a variety of storage services and you should make the decisition as you needs.

The diagram below shows the archtecture details. All AWS resources are built and deployed using Terraform.

![Cloud Arch Diagram](./docs/arch_diagram.png)

## Project Structure

Find the details from [Project Structure](./docs/project_structure.md)

### Local Environment Setup

Find the details from [Local Environment Setup](./docs/local-setup.md)

### Local Deploy

Run below `make` command to deploy specific component.

```bash
# deploy common_infra
make deploy.infra
# deploy lambda_layers
make deploy.layers
# deploy frontend
make deploy.frontend

# useful when there is no change on external denpendencies in requirements-external.txt
make deploy.layers.quick
```

If you have any change on _lambda_layers_, make sure to deploy lambdas as well to use the latest version of layers.

It will spend a few minutes to install terraform providers when you run it firstly. With the scrips run successfully, verify the change from AWS Console.

### Local Destroy

Run below comnand to destroy/remove components from AWS.

As `frontend` depends on `lambda_layers`, you cannot destroy component before destorying its dependencies.

```bash
# deploy common_infra
make destroy.infra
# destroy lambda_layers
make destroy.layers
# destroy frontend
make destroy.frontend

# destroy all resources from AWS in order
make destroy.all
```

### CICD Pipelines
We setup two Jenkins pipelines for CICD.

`Jenkinsfile` is used to deploy/destroy a specific component that you can choose by `Build with Parameters`.

`Jenkinsfile.ci` is used to deploy all components.

Find more information from [CICD Setup](./docs/cicd.md)


## Development
A entry file named `local_invoke.py` that is used to execute the lambda source code locally.

Below is a test case input that get pet by pet id 1.

```bash
python local_invoke.py tests/data/get_pet_by_id.json

# Input:
#   {
#       "resource": "/pets/{petId}",
#       "path": "/pets/1",
#       "httpMethod": "GET",
#       "pathParameters": {
#           "petId": "1"
#       }
#   }

# Output:
#   {
#     "code": "200",
#     "message": "success",
#     "data": {
#       "pets": {
#         "id": 1,
#         "type": "dog",
#         "price": 249.99
#       }
#     },
#     "path": "/pets/1",
#     "traceId": null,
#     "timestamp": 1690860006
#   }
```
## Linting
To keep code quality, passing lint is mandantry to commit your code using pre-commit.

Run the command as below to lint your code.
```bash
make lint
```

See https://pypi.org/project/pylint/ for more information.

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

- https://registry.terraform.io/providers/hashicorp/aws/latest
- https://pipenv.pypa.io/en/latest/
- https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [AWS Lambda Powertools for Python](https://awslabs.github.io/aws-lambda-powertools-python/2.12.0/)
- https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-package.html#gettingstarted-package-layers
- https://github.com/awslabs/aws-lambda-powertools-python