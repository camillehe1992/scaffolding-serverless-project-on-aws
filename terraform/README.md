# Terraform Infrastructure

This directory contains the Terragrunt-managed AWS infrastructure for the
serverless Todos/Users API. Keep Terraform setup and deployment guidance here.

## Structure

```text
terraform/
├── environments/
│   ├── root.hcl
│   ├── dev/
│   └── prod/
├── source/
│   ├── modules/
│   └── units/
└── justfile
```

`source/modules` contains reusable Terraform modules. `source/units` composes
those modules into deployable stacks. `environments` contains the Terragrunt
configuration for each environment and unit.

## Infrastructure Summary

The infrastructure is split into three deployable units:

| Unit | Purpose | Main AWS Resources |
| ---- | ------- | ------------------ |
| `security` | Shared security resources | Lambda execution IAM role and DynamoDB access policy |
| `dynamodb` | Application data stores | Users and todos DynamoDB tables |
| `api` | Runtime API stack | API Gateway, Lambda function, Lambda dependency layer, CloudWatch log groups |

The reusable modules are:

| Module | Purpose |
| ------ | ------- |
| `iam_role` | Creates IAM roles and policy attachments for Lambda execution |
| `dynamodb` | Creates DynamoDB tables used by the application |
| `lambda_function` | Packages and deploys the Python Lambda function |
| `api_gateway` | Creates the REST API, stage, deployment, routes, and logging |
| `vpc_endpoint` | Provides reusable VPC endpoint resources when private AWS service access is needed |

Deploy units in this order:

1. `security`
2. `dynamodb`
3. `api`

Deploy `api` after building the Lambda dependency layer zip.

## Required Tools

Install these tools before running local infrastructure commands:

- AWS CLI
- Terraform
- Terragrunt
- just
- markdownlint-cli
- pre-commit

On macOS:

```bash
brew install awscli terraform terragrunt just markdownlint-cli pre-commit
```

Enable pre-commit hooks after cloning:

```bash
pre-commit install
```

## AWS Credentials

Configure AWS credentials for the target account. The root `justfile` reads
`AWS_PROFILE` from `.env` when present and otherwise falls back to
`app-deployer`.

Example `.env` at the repository root:

```bash
AWS_PROFILE=app-deployer
```

Check the selected profile and paths:

```bash
just show-settings
```

Verify credentials before planning or applying:

```bash
just pre-check dev security
```

## Environments And State

Active Terragrunt environments live under:

```text
terraform/environments/dev
terraform/environments/prod
```

Use `dev` for local development. Treat `prod` as a protected environment and
deploy it only through an approved release process.

The AWS account ID is resolved from the active AWS credentials at runtime. The
region is configured in `terraform/environments/root.hcl`.

Remote state uses an S3 bucket name in this format:

```text
terraform-state-<aws-account-id>-<aws-region>
```

The deployment identity needs permission to create or access that bucket, read
and write state objects, and manage the resources in each unit.

## Plan And Apply

Run commands from the repository root. Plan individual units first:

```bash
just plan dev security
just plan dev dynamodb
```

Build the Lambda dependency layer before planning the API unit:

```bash
just deps-zip
just plan dev api
```

Apply units in dependency order:

```bash
just apply dev security
just apply dev dynamodb
just deps-zip
just apply dev api
```

Show API outputs after apply:

```bash
just output dev api
```

Useful API outputs include `invoke_url`, `swagger_url`, the Lambda function ARN,
and the dependency layer ARN.

## Full Environment Commands

Terragrunt can also run across all units in an environment:

```bash
just plan-all dev
just apply-all dev
just output-all dev
```

For API changes, ensure `.build/dependencies.zip` exists first:

```bash
just deps-zip
just plan-all dev
```

Individual unit commands are usually easier to review because they show the
dependency order explicitly.

## Sample Data

Sample records live in:

```text
data/users.json
data/todos.json
```

After `dynamodb` is deployed, import sample data:

```bash
just import-ddb
```

The import script clears the target tables before loading the sample records, so
review `data/import_to_dynamodb.py` before using it against a shared
environment.

## Validation And Cleanup

Format Terragrunt HCL:

```bash
just hcl-fmt
```

Validate Terragrunt HCL:

```bash
just hcl-validate
```

Clean local Terraform and Terragrunt generated files:

```bash
just clean
```

Per-module and per-unit README files under `terraform/source` are intentionally
not generated. Keep Terraform setup and deployment guidance in this README.

## Destroy Development Infrastructure

Review destroy plans first:

```bash
just plan-destroy dev api
just plan-destroy dev dynamodb
just plan-destroy dev security
```

Destroy development resources in reverse dependency order:

```bash
just destroy dev api
just destroy dev dynamodb
just destroy dev security
```

Avoid destroying shared or production resources from a local workstation.

## Troubleshooting

If Terragrunt cannot resolve the AWS account ID, confirm the selected profile is
configured and active:

```bash
aws sts get-caller-identity --profile app-deployer
```

If API planning fails because the dependency layer zip is missing, run:

```bash
just deps-zip
```

If remote state access fails, confirm the deployment identity can access the
expected S3 state bucket for the target account and region.

## References

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide)
- [just Documentation](https://github.com/casey/just#readme)
