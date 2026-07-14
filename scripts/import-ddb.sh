#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
PROFILE="${1:-}"

echo "[*] Importing data to DynamoDB"

if [ -n "${PROFILE}" ]; then
    AWS_PROFILE="${PROFILE}" python3 "${PROJECT_ROOT}/data/import_to_dynamodb.py"
else
    python3 "${PROJECT_ROOT}/data/import_to_dynamodb.py"
fi
