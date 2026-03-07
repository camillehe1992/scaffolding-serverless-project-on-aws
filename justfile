# justfile - Task runner for Terragrunt workflows
# Usage: just [ENVIRONMENT] [UNIT] task
# Example: just plan dev security

# Default values (can be overridden)
ENVIRONMENT := "dev"
UNIT := "security"

# Project root directory (where the justfile is located)
PROJECT_ROOT := `pwd`

# Shell to use
set shell := ["bash", "-uc"]

# ------------------------------------------------------------------------------
# Helper functions (as recipes)
# ------------------------------------------------------------------------------

# Show help
help:
    @just --list --unsorted

# Get AWS profile from .env or fallback to "app-deployer"
aws-profile:
    #!/usr/bin/env bash
    # Check if running in GitHub Actions
    if [ -n "$GITHUB_ACTIONS" ]; then
        # In GitHub Actions with OIDC, we don't use named profiles
        # The credentials are already set by configure-aws-credentials
        echo ""
    elif [ -f .env ]; then
        source .env && echo "${AWS_PROFILE:-app-deployer}"
    else
        echo "app-deployer"
    fi

# ------------------------------------------------------------------------------
# Path helpers (as recipes)
# ------------------------------------------------------------------------------

# Terragrunt unit directory
tg-unit-dir ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    echo "{{PROJECT_ROOT}}/terraform/environments/{{ENVIRONMENT}}/{{UNIT}}/"

# Terragrunt environment directory
tg-env-dir ENVIRONMENT:
    #!/usr/bin/env bash
    echo "{{PROJECT_ROOT}}/terraform/environments/{{ENVIRONMENT}}/"

# ------------------------------------------------------------------------------
# Core commands
# ------------------------------------------------------------------------------

# Pre-check - Verify AWS credentials
pre-check ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    echo "[*] Pre-Check - AWS Profile ${PROFILE}"
    AWS_PROFILE=${PROFILE} aws sts get-caller-identity | jq .

# Terragrunt plan
plan ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})

    # First run pre-check
    just pre-check {{ENVIRONMENT}} {{UNIT}}

    echo "[*] Terragrunt planning {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt plan

# Terragrunt apply
apply ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})

    echo "[*] Terragrunt applying {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt apply --auto-approve

# Terragrunt destroy
destroy ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})

    echo "[*] Terragrunt destroying {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt destroy --auto-approve

# Terragrunt plan-destroy (plan for destruction)
plan-destroy ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})

    # First run pre-check
    just pre-check {{ENVIRONMENT}} {{UNIT}}

    echo "[*] Terragrunt planning destruction for {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt plan -destroy

# Terragrunt output
output ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})

    echo "[*] Terragrunt output for {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt output

# ------------------------------------------------------------------------------
# Run-all commands (for multiple units)
# ------------------------------------------------------------------------------

# Run-all plan for entire environment
plan-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})

    echo "[*] Terragrunt run-all plan for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all -- plan

# Run-all apply for entire environment
apply-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})

    echo "[*] Terragrunt run-all apply for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all --non-interactive apply

# Run-all destroy for entire environment
destroy-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})

    echo "[*] Terragrunt run-all destroy for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all destroy

# Run-all output for entire environment
output-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})

    echo "[*] Terragrunt run-all output for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all output

# Run-all validate for entire environment
validate-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})

    echo "[*] Terragrunt run-all validate for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all validate

# ------------------------------------------------------------------------------
# Utility commands
# ------------------------------------------------------------------------------

# List all available commands
list:
    @just --list

# Clean up temporary files
clean:
    echo "[*] Cleaning up temporary files"
    find {{PROJECT_ROOT}} -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null || true
    find {{PROJECT_ROOT}} -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
    find {{PROJECT_ROOT}} -type f -name "*.tfstate*" -delete

# Terragrunt fmt (format)
hcl-fmt:
    #!/usr/bin/env bash
    terragrunt hcl format

# Terragrunt validate (validate configuration)
hcl-validate:
    #!/usr/bin/env bash
    terragrunt hcl validate

# Show current settings
show-settings:
    #!/usr/bin/env bash
    echo "ENVIRONMENT: {{ENVIRONMENT}}"
    echo "UNIT: {{UNIT}}"
    echo "PROJECT_ROOT: {{PROJECT_ROOT}}"
    echo "AWS_PROFILE: $(just aws-profile)"

# Generate documentation for all modules and units under source directory
gen-docs:
    #!/usr/bin/env bash
    echo "[*] Generating documentation for modules and units under source directory"

    # Check if terraform-docs is installed
    if ! command -v terraform-docs &> /dev/null; then
        echo "[!] terraform-docs is not installed. Installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install terraform-docs
        else
            echo "[!] Please install terraform-docs manually: https://terraform-docs.io/user-guide/installation/"
            exit 1
        fi
    fi

    # Generate docs for modules in source/modules/
    echo "[*] Generating documentation for modules in source/modules/"
    for module_dir in {{PROJECT_ROOT}}/source/modules/*/; do
        if [ -d "$module_dir" ]; then
            module_name=$(basename "$module_dir")
            echo "  - Processing module: $module_name"
            terraform-docs markdown "$module_dir" > "$module_dir/README.md" || echo "  [!] Failed to generate docs for $module_name"
        fi
    done

    # Generate docs for units in source/units/
    echo "[*] Generating documentation for units in source/units/"
    for unit_dir in {{PROJECT_ROOT}}/source/units/*/; do
        if [ -d "$unit_dir" ]; then
            unit_name=$(basename "$unit_dir")
            echo "  - Processing unit: $unit_name"
            terraform-docs markdown "$unit_dir" > "$unit_dir/README.md" || echo "  [!] Failed to generate docs for $unit_name"
        fi
    done

    echo "[*] Documentation generation completed!"

# ------------------------------------------------------------------------------
# Utility commands for Lambda Source Code
# ------------------------------------------------------------------------------

# Build a Lambda dependencies zip from src/requirements.txt
deps-zip:
    #!/usr/bin/env bash
    set -euo pipefail
    BUILD_DIR="{{PROJECT_ROOT}}/.build"
    DEPS_DIR="$BUILD_DIR/dependencies"
    REQ_FILE="{{PROJECT_ROOT}}/src/requirements.txt"
    DEPS_ZIP="$BUILD_DIR/dependencies.zip"
    echo "[*] Build dependencies zip from $REQ_FILE into $DEPS_ZIP"
    rm -rf "$DEPS_DIR"
    rm -f "$DEPS_ZIP"
    mkdir -p "$DEPS_DIR/python"
    PYTHONDONTWRITEBYTECODE=1 python3 -m pip install --no-cache-dir -r "$REQ_FILE" -t "$DEPS_DIR/python"
    find "$DEPS_DIR" -type d -name "__pycache__" -prune -exec rm -rf {} +
    cd "$DEPS_DIR" && zip -r -q "$DEPS_ZIP" python
    ls -lh "$DEPS_ZIP"

# Import sample data (users and todos) to DynamoDB Tables
import-ddb:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "[*] Importing data to DynamoDB"
    PROFILE=$(just aws-profile)
    AWS_PROFILE=${PROFILE} python3 {{PROJECT_ROOT}}/data/import_to_dynamodb.py
