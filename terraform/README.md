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

| Unit       | Purpose                   | Main AWS Resources                                                           |
| ---------- | ------------------------- | ---------------------------------------------------------------------------- |
| `security` | Shared security resources | Lambda execution IAM role and DynamoDB access policy                         |
| `dynamodb` | Application data stores   | Users and todos DynamoDB tables                                              |
| `api`      | Runtime API stack         | API Gateway, Lambda function, Lambda dependency layer, CloudWatch log groups |

The reusable modules are:

| Module            | Purpose                                                                            |
| ----------------- | ---------------------------------------------------------------------------------- |
| `iam_role`        | Creates IAM roles and policy attachments for Lambda execution                      |
| `dynamodb`        | Creates DynamoDB tables used by the application                                    |
| `lambda_function` | Packages and deploys the Python Lambda function                                    |
| `api_gateway`     | Creates the REST API, stage, deployment, routes, and logging                       |
| `vpc_endpoint`    | Provides reusable VPC endpoint resources when private AWS service access is needed |

Deploy units in this order:

1. `security`
2. `dynamodb`
3. `api`

The `api` unit prepares the Lambda dependency layer zip during Terraform
planning. It rebuilds the zip only when `src/requirements.txt` changes or the
existing zip fails validation.

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
cd terraform
just pre-check dev security
cd ..
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

Run root commands from the repository root. For a normal full-environment
deployment, run the root deployment recipe:

```bash
just deploy dev
```

Unit-specific Terragrunt recipes are available from the `terraform` directory
when you need to inspect or apply one unit at a time. Plan individual units
first:

```bash
cd terraform
just plan dev security
just plan dev dynamodb
just plan dev api
cd ..
```

Apply units in dependency order:

```bash
cd terraform
just apply dev security
just apply dev dynamodb
just apply dev api
cd ..
```

Show API outputs after apply:

```bash
cd terraform
just output dev api
cd ..
```

Useful API outputs include `invoke_url`, `swagger_url`, the Lambda function ARN,
and the dependency layer ARN.

## Full Environment Commands

Terragrunt can also run across all units in an environment:

```bash
just deploy dev
```

For API changes, Terraform validates `.build/dependencies.zip` as part of the
`api` unit plan and rebuilds it when the requirements hash changed:

```bash
cd terraform
just plan-all dev
cd ..
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
cd terraform
just hcl-fmt
cd ..
```

Validate Terragrunt HCL:

```bash
cd terraform
just hcl-validate
cd ..
```

Clean local Terraform and Terragrunt generated files:

```bash
cd terraform
just clean
cd ..
```

Per-module and per-unit README files under `terraform/source` are intentionally
not generated. Keep Terraform setup and deployment guidance in this README.

## Destroy Development Infrastructure

Review destroy plans first:

```bash
cd terraform
just plan-destroy dev api
just plan-destroy dev dynamodb
just plan-destroy dev security
cd ..
```

Destroy the full development environment from the repository root:

```bash
just destroy dev
```

Avoid destroying shared or production resources from a local workstation.

If remote state access fails, confirm the deployment identity can access the
expected S3 state bucket for the target account and region.

## References

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide)
- [just Documentation](https://github.com/casey/just#readme)
