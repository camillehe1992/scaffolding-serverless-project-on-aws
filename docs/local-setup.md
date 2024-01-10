# Local Environment Setup

After downloading the sample code on your local machine, you should setup your local environment for development. For example, you need to create a virtual environment to install your python dependencies if you choose Python as your Lambda function language. Moreover, AWS credentials configuration should be setup if you need to deploy AWS resources to AWS environments.

## Install Terraform CLI

To deploy terraform resources to AWS from local, you need to install Terraform CLI from <https://releases.hashicorp.com/terraform/> according to your PC OS version, and downlaod it as a zip archive.

> In the repo, we specify terraform version as `1.3.6` in backend config of each component we have to install version `1.3.6` from <https://releases.hashicorp.com/terraform/1.3.6/>.

After downloading Terraform zip file, unzip the package. Terraform runs as a single binary named `terraform`. Make sure that the terraform binary is available on environment variable `PATH`. This process will differ depending on your operating system.

```bash
# for Mac or Linux
echo $PATH
```

Move the Terraform binary file to one of the listed locations. Below command assumes that the binary is currently in your `Downloads` folder and your `PATH` includes `/usr/local/bin`.

```bash
mv ~/Downloads/terraform /usr/local/bin/
```

Validate the installation of Terraform CLI by running below command in the terminal.

```bash
terraform --version
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

# Creae an environment named todo-py39
conda create -n todo-py39

# Activate the environment
conda activate todo-py39

# Install python=3.9 on the environment
conda install python=3.9
# or using pip 
pip install python=3.9

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

## Local Test

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

Now, the local development environment is setup.
