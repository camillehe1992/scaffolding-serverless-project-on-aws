#!/usr/bin/env bash
set -u

summary_script="${GITHUB_WORKSPACE}/.github/scripts/write-terragrunt-summary.sh"

if [ -n "${DESTROY_FLAG:-}" ]; then
  terragrunt plan "$DESTROY_FLAG" -detailed-exitcode -no-color > "$PLAN_OUTPUT_FILE" 2>&1
else
  terragrunt plan -detailed-exitcode -no-color > "$PLAN_OUTPUT_FILE" 2>&1
fi

exitcode=$?
echo "exitcode=${exitcode}"

echo "exitcode=${exitcode}" >> "$GITHUB_OUTPUT"

if [ "${exitcode}" -eq 2 ]; then
  bash "$summary_script" plan-preview >> "$GITHUB_STEP_SUMMARY"
fi

if [ "${exitcode}" -eq 1 ]; then
  echo "Terragrunt plan failed."
  cat "$PLAN_OUTPUT_FILE"
  exit 1
else
  exit 0
fi
