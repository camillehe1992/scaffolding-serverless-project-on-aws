# GitHub Actions Workflow Usage Guide

This guide explains how to use the repository GitHub Actions workflows for
Python application checks, release tagging, and Terragrunt-based infrastructure
deployment.

## Workflow Catalog

| Workflow                       | File                                               | Trigger                   | Purpose                                                  |
| ------------------------------ | -------------------------------------------------- | ------------------------- | -------------------------------------------------------- |
| Publish Release Tag                | `.github/workflows/create-release-tag.yml`         | Manual                    | Creates a Git tag and GitHub release from `VERSION.txt`. |
| Deploy Dev Environment             | `.github/workflows/deploy-dev.yml`                 | Push to `main`, manual    | Deploys the full `dev` environment in dependency order.  |
| Deploy Prod Environment            | `.github/workflows/deploy-prod.yml`                | Manual                    | Deploys the full `prod` environment in dependency order. |
| Validate Python App                | `.github/workflows/python-ci.yml`                  | Pull request, push        | Runs unit tests and pylint for the Python application.   |
| Validate Terraform and Workflows   | `.github/workflows/terraform-checks.yml`           | Pull request              | Runs non-AWS Terraform, Terragrunt, and workflow checks. |
| Deploy or Destroy Terragrunt Unit  | `.github/workflows/terragrunt-unit-deploy.yml`     | Manual                    | Plans and applies one Terragrunt unit, or destroys it when `DELETE` is confirmed. |
| Run Terragrunt Unit Plan and Apply | `.github/workflows/reusable-terragrunt-deploy.yml` | Called by other workflows | Shared deployment implementation. Do not run directly.   |

## Validate Python App

`Validate Python App` validates the Lambda application code under `src`.

It runs when:

- A pull request changes `src/**` or `.github/workflows/python-ci.yml`.
- A push to `main` or `develop` changes `src/**` or
  `.github/workflows/python-ci.yml`.

It performs these checks:

- Installs dependencies from `src/requirements-dev.txt`.
- Runs `pytest` for `src/tests/unit/`.
- Runs `pylint` for `src/portal/app`, `src/tests/unit`, and
  `src/tests/conftest.py`.

Use this workflow as the primary CI signal for Python application changes. It
does not validate Terraform or Terragrunt infrastructure changes.

## Validate Terraform And Workflows

`Validate Terraform and Workflows` runs on pull requests that touch Terraform, Terragrunt, or
GitHub Actions workflow files. It does not configure AWS credentials and only
runs static checks:

- Terraform formatting
- Terragrunt HCL formatting
- TFLint
- actionlint with ShellCheck integration for workflow shell scripts

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
changes or the existing zip fails validation. Because plan and apply run in
separate GitHub Actions jobs, the workflow uploads this zip from the plan job
and downloads it before applying the saved plan.

## Required GitHub Configuration

Create GitHub environments named `dev`, `prod-plan`, and `prod` before running
deployment workflows.

Do not configure required reviewers on `dev` unless you want approval before
development jobs start.
Use `prod-plan` for lower-friction production planning variables and `prod` for
protected production apply jobs.

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

Pushing to `main` runs `Deploy Dev Environment`.

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

You can also run `Deploy Dev Environment` manually from **Actions**
when you want to redeploy the full `dev` stack without pushing a new commit.

## Manual Production Deployment

Use `Deploy Prod Environment` when you want to deploy all `prod` units in
dependency order with GitHub environment protections.

The workflow deploys units in this order:

1. `security`
2. `dynamodb`
3. `api`

It targets the Terragrunt `prod` environment, runs the plan job under the
GitHub environment `prod-plan`, and runs the apply job under the GitHub
environment `prod`.

## Manual Unit Deployment

Use `Deploy or Destroy Terragrunt Unit` when you need to deploy one unit without running
the full environment deployment. The workflow supports both `dev` and `prod`.
It also handles one-unit destroy flows when you explicitly confirm
`confirm_destroy=DELETE`.

1. Open the repository in GitHub.
2. Go to **Actions**.
3. Select **Deploy or Destroy Terragrunt Unit**.
4. Select **Run workflow**.
5. Choose the target `environment`.
6. Choose the `unit`.
7. Leave `confirm_destroy` empty for a normal deploy, or type `DELETE` to run
   a destroy plan and destroy apply for that unit.
8. Start the workflow.

Use the normal deploy order when applying related changes:

1. `security`
2. `dynamodb`
3. `api`

Deploy `api` after dependency changes to `src/requirements.txt` or Lambda source
changes. Terraform builds the Lambda dependency layer before reading it into the
`api` unit, reusing the existing zip when the requirements hash still matches.

## Manual Unit Destroy

Use `Deploy or Destroy Terragrunt Unit` for one-unit destroy operations too. Set
`confirm_destroy` to `DELETE` to switch the workflow from deploy mode into
destroy mode.

Destroy units in reverse dependency order:

1. `api`
2. `dynamodb`
3. `security`

Do not destroy shared or production resources unless the target GitHub
environment, AWS account, and approval path have all been verified.

## Release Tagging

`Publish Release Tag` is a manual workflow.

The workflow:

1. Reads the application version from `VERSION.txt`.
2. Creates or updates the matching Git tag.
3. Creates a GitHub release for that tag.

Use this flow when you want to publish a release explicitly, independent of the
normal `dev` deployment workflow.

Update `VERSION.txt` before running the release workflow.

## Reusable Workflow Behavior

`Run Terragrunt Unit Plan and Apply` is called by the automatic and manual
deployment workflows. It performs the common deployment sequence:

1. Checks out the repository.
2. Sets up Python for the `api` unit.
3. Installs Terraform and Terragrunt.
4. Configures AWS credentials with OIDC.
5. Initializes Terragrunt.
6. Runs `terragrunt plan` with detailed exit codes.
7. Uploads `terraform.plan`, plan metadata, readable plan output, and the API
   dependency layer zip artifacts for 7 days.
8. Publishes a plan output preview to the workflow summary when changes are present.
9. Starts a separate apply job only when changes are present and apply is enabled.
10. Publishes apply, plan-only, or no-change details to the workflow summary.

The reusable workflow separates the Terraform target environment from the
GitHub Environment used to gate each job:

- `environment`: the Terragrunt/Terraform target environment. This controls the
  working directory, artifact naming, concurrency groups, and the actual
  infrastructure target such as `dev` or `prod`.
- `plan_environment`: the GitHub Environment attached to the plan job. This can
  differ from `environment` when production planning should use a lighter-weight
  GitHub Environment such as `prod-plan`.
- `apply_environment`: the GitHub Environment attached to the apply job. This
  can differ from `environment` when production apply should use a protected
  GitHub Environment such as `prod`.

Example:

```text
environment=prod
plan_environment=prod-plan
apply_environment=prod
```

In that example, Terraform still targets the single `prod` infrastructure
environment, while GitHub applies different approval and protection rules to
the plan and apply stages.

Plan jobs use a concurrency group of:

```text
plan-<terraform-environment>-<unit>
```

Apply jobs use a concurrency group of:

```text
deploy-<terraform-environment>-<unit>
```

This prevents overlapping deployments for the same Terraform environment and
unit while allowing different units to run according to their workflow
dependencies.

`Validate Terraform and Workflows` runs for pull requests that change workflow files,
`.pre-commit-config.yaml`, Terraform/Terragrunt files, or the API dependency
packaging script at `scripts/build-dependencies-zip.sh`.

The workflow installs `actionlint` on the runner and verifies that
`shellcheck` is available before linting workflow files. This keeps shell
validation enabled for inline Bash used in GitHub Actions jobs.

Common tool versions such as Python, Terraform, and Terragrunt are declared at
the workflow `env` level so each workflow keeps a single local source of truth
for upgrades instead of repeating the same version values across multiple jobs.

Legacy helper scripts under `scripts/ci/` are no longer part of the active
workflow path. Current GitHub Actions automation is defined directly in
`.github/workflows/` and the reusable Terragrunt deployment workflow.

## Operational Checks

Before running a workflow, confirm:

- The target GitHub environment is correct.
- The target GitHub environment maps to the intended Terraform environment.
- `ROLE_TO_ASSUME` points to the expected AWS account.
- `AWS_REGION` matches `terraform/environments/root.hcl`.
- The Terragrunt unit exists under `terraform/environments/<terraform-environment>`.
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
