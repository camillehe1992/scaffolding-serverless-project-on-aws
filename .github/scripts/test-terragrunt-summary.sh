#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
summary_script="${repo_root}/.github/scripts/write-terragrunt-summary.sh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

assert_contains() {
  local file="$1"
  local expected="$2"

  if ! grep -Fq -- "$expected" "$file"; then
    echo "Expected to find: $expected" >&2
    echo "Actual output:" >&2
    cat "$file" >&2
    exit 1
  fi
}

plan_output_file="${tmpdir}/terraform-plan-output.txt"
cat > "${plan_output_file}" <<'EOF'
Terraform used the selected providers to generate the following execution plan.
Plan: 2 to add, 1 to change, 3 to destroy.
EOF

plan_preview_output="${tmpdir}/plan-preview.md"
TERRAFORM_ENVIRONMENT=dev \
UNIT=api \
PLAN_MODE=destroy \
PLAN_SUMMARY_LINES=1 \
PLAN_OUTPUT_FILE="${plan_output_file}" \
bash "${summary_script}" plan-preview > "${plan_preview_output}"

assert_contains "${plan_preview_output}" "### Destroy Plan Summary - dev/api"
assert_contains "${plan_preview_output}" "- Result: Changes detected"
assert_contains "${plan_preview_output}" "- Change summary: 2 to add, 1 to change, 3 to destroy."
assert_contains "${plan_preview_output}" "_Plan output truncated to 1 lines._"

plan_only_output="${tmpdir}/plan-only.md"
TERRAFORM_ENVIRONMENT=prod \
UNIT=security \
PLAN_MODE=apply \
PLAN_OUTPUT_ARTIFACT_NAME=terraform-plan-output-prod-security-apply \
bash "${summary_script}" plan-only > "${plan_only_output}"

assert_contains "${plan_only_output}" "### Apply Plan Summary - prod/security"
assert_contains "${plan_only_output}" "- Result: Changes detected"
assert_contains "${plan_only_output}" "- Next step: Apply was skipped because this run is plan-only."
assert_contains "${plan_only_output}" "- Artifacts: \`terraform-plan-output-prod-security-apply\`"

no_changes_output="${tmpdir}/no-changes.md"
TERRAFORM_ENVIRONMENT=dev \
UNIT=dynamodb \
PLAN_MODE=apply \
bash "${summary_script}" no-changes > "${no_changes_output}"

assert_contains "${no_changes_output}" "### Apply Plan Summary - dev/dynamodb"
assert_contains "${no_changes_output}" "- Result: No infrastructure changes"
assert_contains "${no_changes_output}" "- Next step: No apply job will run."

apply_failed_file="${tmpdir}/apply-failed.txt"
cat > "${apply_failed_file}" <<'EOF'
aws_lambda_function.example: Modifying... [id=example]
Error: boom
EOF

apply_failed_output="${tmpdir}/apply-failed.md"
TERRAFORM_ENVIRONMENT=dev \
UNIT=api \
PLAN_MODE=apply \
SUMMARY_EXITCODE=1 \
SUMMARY_INPUT_FILE="${apply_failed_file}" \
bash "${summary_script}" apply-result > "${apply_failed_output}"

assert_contains "${apply_failed_output}" "### Apply Result Summary - dev/api"
assert_contains "${apply_failed_output}" "- Result: Apply failed"
assert_contains "${apply_failed_output}" "- Next step: Review the error output below before retrying."
assert_contains "${apply_failed_output}" "Error: boom"

echo "Terragrunt summary tests passed."
