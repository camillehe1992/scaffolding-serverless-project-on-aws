## Local Environment Setup
After downloading the sample code on your local machine, you should setup your local environment for development. For example, you need to create a virtual environment to install your python dependencies if you choose Python as your Lambda function language. Moreover, AWS credentials configuration should be setup if you need to deploy AWS resources you defined to AWS environments.

### Install Terraform CLI

To deploy terraform resources to AWS from local, you need to install Terraform CLI from https://releases.hashicorp.com/terraform/ according to your PC OS version, and downlaod it as a zip archive.

> In the repo, we specify terraform version as `1.3.4` in backend config of each component we have to install version `1.3.4` from https://releases.hashicorp.com/terraform/1.3.4/.

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

### Install AWS CLI

Install AWS CLI on local machine following https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.

AWS provides a number of ways to configure AWS credentials, you can find the details from https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html. In this repo, we already have a IAM User with permissions created for the deployment. Then generate AKSK (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) for AWS CLI. Run `aws configure` to setup the AKSK as below

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
#       "Arn": "arn:aws-cn:iam::xxxxxxxxxxxx:user/user_name"
#   }
```

### Install Pipenv and Dependencies

AWS Lambda function's code consists of scripts or compiled programs and their dependencies. We use a deployment package to deploy function code to Lambda. Lambda supports two types of deployment packages: container images and .zip file archives. In this project, we use .zip file archieves and `pipenv` for python dependencies management.

Pipenv manages dependencies on a per-project basis. To install pipenv packages, change into your project’s directory and run:

```bash
# install pipenv using pip on local machine. Find the pipenv command in Makefile.
make install
# install python dependencies in Pipefile
make dev
```
Done.