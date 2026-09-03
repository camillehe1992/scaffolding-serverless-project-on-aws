#!/usr/bin/env bash
set -euo pipefail

summary_kind="${1:?summary kind is required}"

mode_label() {
  if [ "${PLAN_MODE}" = "destroy" ]; then
    echo "Destroy"
  else
    echo "Apply"
  fi
}

summary_title() {
  local stage="$1"
  echo "### $(mode_label) ${stage} Summary - ${TERRAFORM_ENVIRONMENT}/${UNIT}"
}

print_common_metadata() {
  echo "- Environment: \`${TERRAFORM_ENVIRONMENT}\`"
  echo "- Unit: \`${UNIT}\`"
  echo "- Mode: \`${PLAN_MODE}\`"
}

extract_change_summary() {
  local input_file="$1"
  local plan_summary
  local apply_summary

  plan_summary="$(grep -Eo 'Plan: [0-9]+ to add, [0-9]+ to change, [0-9]+ to destroy\.' "$input_file" | tail -n 1 || true)"
  if [ -n "${plan_summary}" ]; then
    echo "${plan_summary#Plan: }"
    return 0
  fi

  apply_summary="$(grep -Eo '(Apply|Destroy) complete! Resources: [0-9]+ added, [0-9]+ changed, [0-9]+ destroyed\.' "$input_file" | tail -n 1 || true)"
  if [ -n "${apply_summary}" ]; then
    echo "${apply_summary#*! Resources: }"
  fi
}

render_details_block() {
  local input_file="$1"
  local code_language="$2"
  local max_lines="${3:-0}"
  local total_lines

  total_lines=$(wc -l < "$input_file" | tr -d ' ')

  echo "<details><summary>Click to expand raw output</summary>"
  echo ""
  echo "\`\`\`${code_language}"
  if [ "$max_lines" -gt 0 ] && [ "$total_lines" -gt "$max_lines" ]; then
    head -n "$max_lines" "$input_file"
  else
    cat "$input_file"
  fi
  echo "\`\`\`"

  if [ "$max_lines" -gt 0 ] && [ "$total_lines" -gt "$max_lines" ]; then
    echo ""
    echo "_Plan output truncated to ${max_lines} lines._"
  fi

  echo "</details>"
}

case "$summary_kind" in
  plan-preview)
    change_summary="$(extract_change_summary "${PLAN_OUTPUT_FILE}")"
    summary_title "Plan"
    echo ""
    print_common_metadata
    echo "- Result: Changes detected"
    if [ -n "${change_summary}" ]; then
      echo "- Change summary: ${change_summary}"
    fi
    if [ -n "${PLAN_OUTPUT_ARTIFACT_NAME:-}" ]; then
      echo "- Artifacts: \`${PLAN_OUTPUT_ARTIFACT_NAME}\`"
    fi
    echo "- Next step: Review the plan preview below and the uploaded artifact before apply."
    echo ""
    render_details_block "${PLAN_OUTPUT_FILE}" terraform "${PLAN_SUMMARY_LINES}"
    ;;
  plan-only)
    summary_title "Plan"
    echo ""
    print_common_metadata
    echo "- Result: Changes detected"
    if [ -n "${PLAN_OUTPUT_ARTIFACT_NAME:-}" ]; then
      echo "- Artifacts: \`${PLAN_OUTPUT_ARTIFACT_NAME}\`"
    fi
    echo "- Next step: Apply was skipped because this run is plan-only."
    ;;
  no-changes)
    summary_title "Plan"
    echo ""
    print_common_metadata
    echo "- Result: No infrastructure changes"
    echo "- Next step: No apply job will run."
    ;;
  apply-result)
    change_summary="$(extract_change_summary "${SUMMARY_INPUT_FILE}")"
    summary_title "Result"
    echo ""
    print_common_metadata
    if [ "${SUMMARY_EXITCODE}" -eq 0 ]; then
      echo "- Result: Apply completed"
      echo "- Next step: No further action is required unless you want to inspect the raw output."
    else
      echo "- Result: Apply failed"
      echo "- Next step: Review the error output below before retrying."
    fi
    if [ -n "${change_summary}" ]; then
      echo "- Change summary: ${change_summary}"
    fi
    echo ""
    render_details_block "${SUMMARY_INPUT_FILE}" terraform
    ;;
  *)
    echo "Unsupported summary kind: ${summary_kind}" >&2
    exit 1
    ;;
esac
