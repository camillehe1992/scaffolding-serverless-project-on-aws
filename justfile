# Root justfile - common project commands
# Default values (can be overridden)

ENVIRONMENT := "dev"

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
    echo "PROJECT_ROOT: {{ PROJECT_ROOT }}"
    echo "TERRAFORM_ROOT: {{ TERRAFORM_ROOT }}"
    echo "AWS_PROFILE: $(just aws-profile)"

# ------------------------------------------------------------------------------
# Terraform/Terragrunt command shims
# ------------------------------------------------------------------------------

_terraform RECIPE *ARGS:
    @just --justfile "{{ TERRAFORM_JUSTFILE }}" --working-directory "{{ TERRAFORM_ROOT }}" "{{ RECIPE }}" {{ ARGS }}

# Run plan and apply for entire environment
deploy ENVIRONMENT:
    @just _terraform plan-all "{{ ENVIRONMENT }}"
    @just _terraform apply-all "{{ ENVIRONMENT }}"

# Run destroy for entire environment
destroy ENVIRONMENT:
    @just _terraform destroy-all "{{ ENVIRONMENT }}"

# ------------------------------------------------------------------------------
# Utility commands for Lambda source code
# ------------------------------------------------------------------------------

# Build a Lambda dependencies zip from src/requirements.txt
deps-zip:
    @bash "{{ PROJECT_ROOT }}/scripts/build-dependencies-zip.sh"

# Import sample data (users and todos) to DynamoDB Tables
import-ddb:
    @bash "{{ PROJECT_ROOT }}/scripts/import-ddb.sh" "$(just aws-profile)"
