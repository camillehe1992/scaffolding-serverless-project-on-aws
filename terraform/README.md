# Terraform Environment Setup

Setup local environment in order to deploy AWS infrastructure into AWS account.

## Install Required Tools on Local Machine

To deploy AWS infrastructure into AWS account, you need to have below tools installed on local machine:

- Terragrunt: [Official Installation Guide](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- Terraform: [Official Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- AWS CLI: [Official Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- just: [Official Installation Guide](https://github.com/casey/just#installation)
- markdownlint-cli: [Official Installation Guide](https://github.com/DavidAnson/markdownlint-cli#installation)
- terraform-docs: [Official Installation Guide](https://terraform-docs.io/user-guide/installation/)
- pre-commit: [Official Installation Guide](https://pre-commit.com/#install)

For MacOS users, you can use Homebrew to install Terraform and AWS CLI and other necessary packages using `brew` as below:

  ```bash
  brew install awscli terragrunt terraform just markdownlint-cli terraform-docs pre-commit
  ```

Enable `pre-commit` hooks by running below command:

```bash
pre-commit install
```

## Setup AWS Credentials

After installation, you need to set up AWS credentials for Terraform to use. Please follow the [Official Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html). Run below `just` recipe to check if AWS credentials are set up correctly.

```bash
just pre-check dev security

# Output Exmaple:
# {
#   "UserId": "AIDAXXXXXXXXXXXXXXX",
#   "Account": "123456789012",
#   "Arn": "arn:aws:iam::123456789012:user/app-deployer"
# }
```

## Plan & Apply Infrastructure Changes

Once you have set up AWS credentials, you can use Terragrunt to plan and apply infrastructure changes. There are some `just` recipes to help you with this process.

`unit` can be one of `security`, `api`, `dynamodb`.
`env` can be one of `dev`, `prod`.

> NEVER use `prod` environment for local development in a real world.

### For Individual Unit

- `just plan <env> <unit>`: Plan specific unit of infrastructure changes for specific environment.
- `just apply <env> <unit>`: Apply specific unit of infrastructure changes for specific environment.
- `just destroy <env> <unit>`: Destroy specific unit of infrastructure for specific environment.
- `just plan-destroy <env> <unit>`: Plan destruction of specific unit of infrastructure for specific environment.
- `just output <env> <unit>`: Show output of specific unit of infrastructure for specific environment.

### For All Units

- `just plan-all <env>`: Plan all infrastructure changes for specific environment.
- `just apply-all <env>`: Apply all infrastructure changes for specific environment.
- `just destroy-all <env>`: Destroy all infrastructure for specific environment.
- `just output-all <env>`: Show output of all infrastructure for specific environment.
- `just validate-all <env>`: Validate all infrastructure for specific environment.

Use Cases:

1. Plan and apply security unit changes for dev environment:

	```bash
	just plan dev security
	just apply dev security
	```

2. Destroy security unit for dev environment:

	```bash
	just destroy dev security
	```

3. Plan and apply all infrastructure changes for dev environment:

	```bash
	just plan-all dev
	just apply-all dev
	```

4. Destroy all infrastructure for dev environment:

	```bash
	just destroy-all dev
	```

## Formating & Linting & Documentation Generation

we also provide some `just` recipes to help you with this process.

- `just clean`: Clean up all Terraform cache files.
- `just hcl-fmt`: Format all Terraform files using `terragrunt hcl format`.
- `just hcl-validate`: Validate all Terraform files using `terragrunt hcl validate`.
- `just gen-docs`: Generate documentation for all modules and units under source directory.

## References

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/index.html)
- [just Documentation](https://github.com/casey/just#readme)
- [markdownlint-cli Documentation](https://github.com/DavidAnson/markdownlint-cli#readme)
- [terraform-docs Documentation](https://terraform-docs.io/user-guide/installation/)
