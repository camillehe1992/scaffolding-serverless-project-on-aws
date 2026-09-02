#!/usr/bin/env bash
set -euo pipefail

terragrunt_output=$(terragrunt apply -auto-approve -no-color terraform.plan)

delimiter="$(openssl rand -hex 8)"
{
  echo "summary<<${delimiter}"
  echo "### Terragrunt Apply Output - ${TERRAFORM_ENVIRONMENT}/${UNIT}"
  echo "<details><summary>Click to expand</summary>"
  echo ""
  echo '```terraform'
  echo "$terragrunt_output"
  echo '```'
  echo "</details>"
  echo "${delimiter}"
} >> "$GITHUB_OUTPUT"
