#!/usr/bin/env bash
set -euo pipefail

{
  echo "github_sha=${GITHUB_SHA}"
  echo "github_ref=${GITHUB_REF}"
  echo "github_environment=${GITHUB_ENVIRONMENT_NAME}"
  echo "terraform_environment=${TERRAFORM_ENVIRONMENT}"
  echo "unit=${UNIT}"
  echo "plan_mode=${PLAN_MODE}"
  echo "is_destroy=${IS_DESTROY}"
} > "$PLAN_METADATA_FILE"
