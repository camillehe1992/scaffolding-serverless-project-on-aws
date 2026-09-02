#!/usr/bin/env bash
set -u

if [ -n "${DESTROY_FLAG:-}" ]; then
  terragrunt plan "$DESTROY_FLAG" -detailed-exitcode -no-color > "$PLAN_OUTPUT_FILE" 2>&1
else
  terragrunt plan -detailed-exitcode -no-color > "$PLAN_OUTPUT_FILE" 2>&1
fi

exitcode=$?
echo "exitcode=${exitcode}"

echo "exitcode=${exitcode}" >> "$GITHUB_OUTPUT"

if [ "${exitcode}" -eq 2 ]; then
  total_lines=$(wc -l < "$PLAN_OUTPUT_FILE" | tr -d ' ')

  {
    echo "### Terragrunt Plan Output - ${TERRAFORM_ENVIRONMENT}/${UNIT}"
    echo "<details><summary>Click to expand</summary>"
    echo ""
    echo '```terraform'
    head -n "$PLAN_SUMMARY_LINES" "$PLAN_OUTPUT_FILE"
    echo '```'
    if [ "$total_lines" -gt "$PLAN_SUMMARY_LINES" ]; then
      echo ""
      echo "_Plan output truncated to ${PLAN_SUMMARY_LINES} lines. See the readable plan output artifact for the full text._"
    fi
    echo ""
    echo "_Full readable plan output is uploaded as a workflow artifact._"
    echo "</details>"
  } >> "$GITHUB_STEP_SUMMARY"
fi

if [ "${exitcode}" -eq 1 ]; then
  echo "Terragrunt plan failed."
  cat "$PLAN_OUTPUT_FILE"
  exit 1
else
  exit 0
fi
