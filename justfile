# Root justfile - common project commands
# Default values (can be overridden)

ENVIRONMENT := "dev"
UNIT := "security"

# Project paths

PROJECT_ROOT := justfile_directory()
TERRAFORM_ROOT := PROJECT_ROOT / "terraform"
TERRAFORM_JUSTFILE := TERRAFORM_ROOT / "justfile"

# Shell to use

set shell := ["bash", "-uc"]

# ------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------

# Show help
help:
    @just --list --unsorted

# List all available commands
list:
    @just --list

# Get AWS profile from .env or fallback to "app-deployer"
aws-profile:
    #!/usr/bin/env bash
    if [ -n "$GITHUB_ACTIONS" ]; then
        echo ""
    elif [ -f "{{ PROJECT_ROOT }}/.env" ]; then
        source "{{ PROJECT_ROOT }}/.env" && echo "${AWS_PROFILE:-app-deployer}"
    else
        echo "app-deployer"
    fi

# Show current root settings
show-settings:
    #!/usr/bin/env bash
    echo "ENVIRONMENT: {{ ENVIRONMENT }}"
    echo "UNIT: {{ UNIT }}"
    echo "PROJECT_ROOT: {{ PROJECT_ROOT }}"
    echo "TERRAFORM_ROOT: {{ TERRAFORM_ROOT }}"
    echo "AWS_PROFILE: $(just aws-profile)"

# ------------------------------------------------------------------------------
# Terraform/Terragrunt command shims
# ------------------------------------------------------------------------------

# Terragrunt unit directory
tg-unit-dir ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" tg-unit-dir "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Terragrunt environment directory
tg-env-dir ENVIRONMENT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" tg-env-dir "{{ ENVIRONMENT }}"

# Pre-check - Verify AWS credentials
pre-check ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" pre-check "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Terragrunt plan
plan ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" plan "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Terragrunt apply
apply ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" apply "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Terragrunt destroy
destroy ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" destroy "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Terragrunt plan-destroy
plan-destroy ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" plan-destroy "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Terragrunt output
output ENVIRONMENT UNIT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" output "{{ ENVIRONMENT }}" "{{ UNIT }}"

# Run-all plan for entire environment
plan-all ENVIRONMENT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" plan-all "{{ ENVIRONMENT }}"

# Run-all apply for entire environment
apply-all ENVIRONMENT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" apply-all "{{ ENVIRONMENT }}"

# Run-all destroy for entire environment
destroy-all ENVIRONMENT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" destroy-all "{{ ENVIRONMENT }}"

# Run-all output for entire environment
output-all ENVIRONMENT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" output-all "{{ ENVIRONMENT }}"

# Run-all validate for entire environment
validate-all ENVIRONMENT:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" validate-all "{{ ENVIRONMENT }}"

# Clean Terraform/Terragrunt generated files
clean:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" clean

# Terragrunt fmt
hcl-fmt:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" hcl-fmt

# Terragrunt validate
hcl-validate:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" hcl-validate

# Generate Terraform module and unit documentation
gen-docs:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" gen-docs

# ------------------------------------------------------------------------------
# Utility commands for Lambda source code
# ------------------------------------------------------------------------------

# Build a Lambda dependencies zip from src/requirements.txt
deps-zip:
    #!/usr/bin/env bash
    set -euo pipefail
    BUILD_DIR="{{ PROJECT_ROOT }}/.build"
    DEPS_DIR="$BUILD_DIR/dependencies"
    REQ_FILE="{{ PROJECT_ROOT }}/src/requirements.txt"
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
    AWS_PROFILE=${PROFILE} python3 "{{ PROJECT_ROOT }}/data/import_to_dynamodb.py"
