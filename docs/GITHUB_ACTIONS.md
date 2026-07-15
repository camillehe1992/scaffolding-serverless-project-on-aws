# GitHub Actions Workflow Usage Guide

This guide explains how to use the repository GitHub Actions workflows for
release tagging and Terragrunt-based infrastructure deployment.

## Workflow Catalog

| Workflow                       | File                                               | Trigger                   | Purpose                                                  |
| ------------------------------ | -------------------------------------------------- | ------------------------- | -------------------------------------------------------- |
| Create Release Tag             | `.github/workflows/create-release-tag.yml`         | Push to `main`            | Creates a Git tag and GitHub release from `VERSION.txt`. |
| Deploy Development Environment | `.github/workflows/deploy-dev.yml`                 | Push to `main`            | Deploys the full `dev` environment in dependency order.  |
| Terragrunt Unit Deploy         | `.github/workflows/terragrunt-unit-deploy.yml`     | Manual                    | Plans and applies one Terragrunt unit.                   |
| Terragrunt Unit Destroy        | `.github/workflows/terragrunt-unit-destroy.yml`    | Manual                    | Plans and destroys one Terragrunt unit.                  |
| Reusable Terragrunt Deployment | `.github/workflows/reusable-terragrunt-deploy.yml` | Called by other workflows | Shared deployment implementation. Do not run directly.   |

## Deployment Model

Infrastructure is deployed with Terragrunt from:

```text
terraform/environments/<environment>/<unit>
```

The active deployment units are:

| Unit       | Deploy Order | Destroy Order | Notes                                                |
| ---------- | ------------ | ------------- | ---------------------------------------------------- |
| `security` | 1            | 3             | Creates shared IAM resources.                        |
| `dynamodb` | 2            | 2             | Creates application data tables.                     |
| `api`      | 3            | 1             | Creates API Gateway, Lambda, Lambda layer, and logs. |

The `api` Terraform unit prepares the Lambda dependency layer during planning
via the Terraform external provider. The generated file is
`.build/dependencies.zip`; it is rebuilt only when `src/requirements.txt`
changes or the existing zip fails validation.

## Required GitHub Configuration

Create a GitHub environment named `dev` before running deployment workflows.
Configure protection rules on this environment if manual approval is required
before applying infrastructure changes.

Set these environment or repository variables:

| Variable            | Required | Description                                                   |
| ------------------- | -------- | ------------------------------------------------------------- |
| `ROLE_TO_ASSUME`    | Yes      | AWS IAM role ARN used by GitHub OIDC.                         |
| `ROLE_SESSION_NAME` | No       | AWS role session name. Defaults to `github-actions-<run-id>`. |
| `AWS_REGION`        | No       | AWS region. Defaults to `ap-southeast-1`.                     |

The deployment role must be trusted for GitHub Actions OIDC and must have
permissions to:

- Read and write the Terragrunt S3 remote state bucket.
- Manage IAM resources for the `security` unit.
- Manage DynamoDB resources for the `dynamodb` unit.
- Manage API Gateway, Lambda, CloudWatch Logs, and related resources for the
  `api` unit.

## Automatic Development Deployment

Pushing to `main` runs `Deploy Development Environment`.

The workflow deploys units in this order:

1. `security`
2. `dynamodb`
3. `api`

Each unit calls the shared reusable workflow. A Terragrunt plan runs first. If
the plan exits with code `0`, the job publishes a no-changes summary and stops.
If the plan exits with code `2`, the job applies the saved `terraform.plan`.
If the plan exits with code `1`, the job fails and does not apply changes.

Use this workflow for normal development environment updates after changes are
merged to `main`.

## Manual Unit Deployment

Use `Terragrunt Unit Deploy` when you need to deploy one unit without running
the full development deployment.

1. Open the repository in GitHub.
2. Go to **Actions**.
3. Select **Terragrunt Unit Deploy**.
4. Select **Run workflow**.
5. Choose the target `environment`.
6. Choose the `unit`.
7. Start the workflow.

Use the normal deploy order when applying related changes:

1. `security`
2. `dynamodb`
3. `api`

Deploy `api` after dependency changes to `src/requirements.txt` or Lambda source
changes. Terraform builds the Lambda dependency layer before reading it into the
`api` unit, reusing the existing zip when the requirements hash still matches.

## Manual Unit Destroy

Use `Terragrunt Unit Destroy` only when development infrastructure should be
removed.

1. Open the repository in GitHub.
2. Go to **Actions**.
3. Select **Terragrunt Unit Destroy**.
4. Select **Run workflow**.
5. Choose the target `environment`.
6. Choose the `unit`.
7. Start the workflow.

Destroy units in reverse dependency order:

1. `api`
2. `dynamodb`
3. `security`

Do not destroy shared or production resources unless the target GitHub
environment, AWS account, and approval path have all been verified.

## Release Tagging

Pushing to `main` also runs `Create Release Tag`.

The workflow:

1. Reads the application version from `VERSION.txt`.
2. Creates or updates the matching Git tag.
3. Creates a GitHub release for that tag.

Update `VERSION.txt` before merging release changes to `main`.

## Reusable Workflow Behavior

`Reusable Terragrunt Deployment` is called by the automatic and manual
deployment workflows. It performs the common deployment sequence:

1. Checks out the repository.
2. Sets up Python for the `api` unit.
3. Installs Terraform and Terragrunt.
4. Configures AWS credentials with OIDC.
5. Initializes Terragrunt.
6. Runs `terragrunt plan` with detailed exit codes.
7. Uploads `terraform.plan` as a GitHub Actions artifact for 7 days.
8. Applies `terraform.plan` only when changes are present.
9. Publishes apply or no-change details to the workflow summary.

Deployment jobs use a concurrency group of:

```text
deploy-<environment>-<unit>
```

This prevents overlapping deployments for the same environment and unit while
allowing different units to run according to their workflow dependencies.

## Operational Checks

Before running a workflow, confirm:

- The target GitHub environment is correct.
- `ROLE_TO_ASSUME` points to the expected AWS account.
- `AWS_REGION` matches `terraform/environments/root.hcl`.
- The Terragrunt unit exists under `terraform/environments/<environment>`.
- `VERSION.txt` has the intended value before release tagging.

After a workflow completes, review:

- The job status for each unit.
- The workflow summary for Terragrunt apply output.
- AWS resources and Terraform state if a deployment changed infrastructure.
- API outputs from Terragrunt or AWS when the `api` unit changes.

## Troubleshooting

If AWS credentials fail, verify `ROLE_TO_ASSUME`, the GitHub OIDC trust policy,
and the target GitHub environment variables.

If Terragrunt init fails, verify the deployment role can access the expected S3
state bucket:

```text
terraform-state-<aws-account-id>-<aws-region>
```

If the `api` unit fails while packaging dependencies, check `src/requirements.txt`
and the Python version configured in the workflow.

If a manual workflow does not appear in the Actions tab, confirm the workflow
file is on the default branch and has a valid `workflow_dispatch` trigger.

If a deployment is waiting, check GitHub environment protection rules and any
required reviewers for the target environment.
