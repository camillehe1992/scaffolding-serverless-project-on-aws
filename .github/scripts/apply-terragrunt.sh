#!/usr/bin/env bash
set -euo pipefail

summary_script="${GITHUB_WORKSPACE}/.github/scripts/write-terragrunt-summary.sh"
summary_input_file="$(mktemp)"
trap 'rm -f "${summary_input_file}"' EXIT

set +e
terragrunt apply -auto-approve -no-color terraform.plan > "${summary_input_file}" 2>&1
exitcode=$?
set -e

SUMMARY_EXITCODE="${exitcode}" \
SUMMARY_INPUT_FILE="${summary_input_file}" \
bash "${summary_script}" apply-result >> "$GITHUB_STEP_SUMMARY"

if [ "${exitcode}" -ne 0 ]; then
  cat "${summary_input_file}"
  exit "${exitcode}"
fi
