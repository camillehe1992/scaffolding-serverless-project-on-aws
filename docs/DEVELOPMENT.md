# Local Development Environment Setup

After downloading the sample code on your local machine, you should setup your local environment for development. For example, you need to create a virtual environment to install your python dependencies if you choose Python as your Lambda function language. Moreover, AWS credentials configuration should be setup if you need to deploy AWS resources to AWS environments.

- [Local Development Environment Setup](#local-development-environment-setup)
  - [Install Terraform CLI](#install-terraform-cli)
  - [Install AWS CLI](#install-aws-cli)
  - [Install Anaconda and Dependencies](#install-anaconda-and-dependencies)
  - [Install Project Dependencies](#install-project-dependencies)
  - [Enable Pre Commit](#enable-pre-commit)
  - [Testing](#testing)
    - [Local Lambda Test](#local-lambda-test)
    - [Unit Test](#unit-test)
    - [E2E Test](#e2e-test)
    - [Postman](#postman)
  - [Linting \& Formatting](#linting--formatting)

## Install Terraform CLI

Terraform provides several ways to install Terraform CLI on machine in its official website, but I recommend to use `tfenv` which is a [Terraform](https://www.terraform.io/) version manager inspired by `rbenv`. With `tfenv`, you are able to manage and switch between multiple Terraform versions easily when you have to work on many projects using different Terraform versions.

I installed `tfenv` manually on my desktop (MacBook Air M2) following the `tfenv` [README](https://github.com/tfutils/tfenv).

Firstly, you check out `tfenv` into any path (for me, it's my user home root path ${HOME}/.tfenv).

```bash
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
```

Then, make symlinks for `tfenv/bin/*` scripts into a path that is already added to your $PATH (e.g. /usr/local/bin) OSX/Linux Only!

```bash
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

Open another terminal, and run `tfenv -v` to check if the installation works. Finally, install Terrafrom version you required using command `tfenv install x.x.x`. In this repo, I use Terraform version `1.8.0`, so run below command to install `1.8.0`.

```bash
tfenv install 1.8.0

# Switch to use 1.8.0
tfenv use 1.8.0

# validate current Terraform version
terraform -v
# Terraform v1.3.6
# on darwin_arm64
```

## Install AWS CLI

Install AWS CLI on local machine following <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>.

AWS provides a number of ways to configure AWS credentials, you can find the details from <https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html>. In this repo, we already have a IAM User with permissions created for the deployment. Then generate AKSK (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) for AWS CLI. Run `aws configure` to setup the AKSK as below

```bash
aws configure
# AWS Access Key ID [None]: XXXXXXXXXXXXXXXXXX
# AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Default region name [None]: cn-north-1
# Default output format [None]: json
```

After done, the credentials is located at `~/.aws/credentials` on your local machine. You can have muliple credentials configured in the credentials file, each one have a profile name. The profile name is `default` on default. You can use environment variable `AWS_PROFILE` to specify the AKSK to use.

```bash
# ~/.aws/credentials
[default]
aws_access_key_id = XXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Run below command to verify the configuration works well.

```bash
aws sts get-caller-identity

# Output
#   {
#       "UserId": "XXXXXXXXXXXXXXXXXXXX",
#       "Account": "xxxxxxxxxxxx",
#       "Arn": "arn:${aws.partition}:iam::xxxxxxxxxxxx:user/user_name"
#   }
```

## Install Anaconda and Dependencies

AWS Lambda function's code consists of scripts or compiled programs and their dependencies. We use a deployment package to deploy function code to Lambda. Lambda supports two types of deployment packages: container images and .zip file archives. In this project, we use .zip file archieves and `conda` for python dependencies management.

You can use other python version management tools you prefered, such as [pipenv](https://pipenv.pypa.io/en/latest/), [poetry](https://python-poetry.org/). For me, I use [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) here.

When you have Ananconda installed on your local machine, create a virtual environment for your project, then install python dependencies in it.

```bash
conda -V
# conda 24.4.0

# Creae an environment named todo-py10
conda create -n todo-py10

# Activate the environment
conda activate todo-py10

# Install python=3.10 on the environment
conda install python=3.10
# or using pip
pip install python=3.10

# List all packages installed in the environment
conda list
```

## Install Project Dependencies

Install python dependencies (including dependencies for development) in the virtual environment.

```bash
pip install -r requirements-dev.txt
```

## Enable Pre Commit

A framework for managing and maintaining multi-language pre-commit hooks. See <https://pre-commit.com/> for more information.

Git hook scripts are useful for identifying simple issues before submission to code review. We run our hooks on every commit to automatically point out issues in code such as missing semicolons, trailing whitespace, and debug statements. By pointing these issues out before code review, this allows a code reviewer to focus on the architecture of a change while not wasting time with trivial style nitpicks.

Each time you commit your code on local, these hooks will be triggered to validate as configured. Except for some pre-commit provided hooks, we also add another customized hook, for example `pylint` to make sure your code follow and pass all rules defined in _pylintrc_ file. You can run `make lint` at any time to check the code lint result.

Currently, we enabled hooks for pre-commit in configuration file `.git-commit-config.yaml`, which means you have to get all hooks passed before creating a git commit successfully.

Run below command to enable pre-commit hook on local.

```bash
pre-commit install
# output: pre-commit installed at .git/hooks/pre-commit
```

## Testing

### Local Lambda Test

Run lambda function in python on local machine usin [python-lambda-local](https://pypi.org/project/python-lambda-local/). All local test files locates in `src/local_test` folder.

```bash
# Test GET /todos with event defined in src/local_test/events folder
python -m src.local_test.local_get_todos

# Outputs
# [root - INFO - 2024-01-12 13:13:35,928] Event: {'resource': '/todos', 'path': '/todos', 'httpMethod': 'GET', 'body': None}
# [root - INFO - 2024-01-12 13:13:35,928] START RequestId: d01e81a9-332a-4fd6-88a3-c3c2ba224692 Version: $LATEST
# [root - INFO - 2024-01-12 13:13:37,018] END RequestId: d01e81a9-332a-4fd6-88a3-c3c2ba224692
# [root - INFO - 2024-01-12 13:13:37,018] REPORT RequestId: d01e81a9-332a-4fd6-88a3-c3c2ba224692  Duration: 937.32 ms
# [root - INFO - 2024-01-12 13:13:37,018] RESULT:
# {'statusCode': <HTTPStatus.OK: 200>, 'body': '{"todos":[{"userId":1,"id":1,"title":"delectus aut autem","completed":false},{"userId":1,"id":2,"title":"quis ut nam facilis et officia qui","completed":false},{"userId":1,"id":3,"title":"fugiat veniam minus","completed":false},{"userId":1,"id":4,"title":"et porro tempora","completed":true},{"userId":1,"id":5,"title":"laboriosam mollitia et enim quasi adipisci quia provident illum","completed":false},{"userId":1,"id":6,"title":"qui ullam ratione quibusdam voluptatem quia omnis","completed":false},{"userId":1,"id":7,"title":"illo expedita consequatur quia in","completed":false},{"userId":1,"id":8,"title":"quo adipisci enim quam ut ab","completed":true},{"userId":1,"id":9,"title":"molestiae perspiciatis ipsa","completed":false},{"userId":1,"id":10,"title":"illo est ratione doloremque quia maiores aut","completed":true}]}', 'isBase64Encoded': False, 'multiValueHeaders': defaultdict(<class 'list'>, {'Content-Type': ['application/json']})}
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
