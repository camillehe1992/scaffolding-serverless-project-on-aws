#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)

BUILD_DIR="${PROJECT_ROOT}/.build"
DEPS_DIR="${BUILD_DIR}/dependencies"
REQ_FILE="${PROJECT_ROOT}/src/requirements.txt"
DEPS_ZIP="${BUILD_DIR}/dependencies.zip"

echo "[*] Build dependencies zip from ${REQ_FILE} into ${DEPS_ZIP}"

rm -rf "${DEPS_DIR}"
rm -f "${DEPS_ZIP}"
mkdir -p "${DEPS_DIR}/python"

PYTHONDONTWRITEBYTECODE=1 python3 -m pip install \
    --no-cache-dir \
    -r "${REQ_FILE}" \
    -t "${DEPS_DIR}/python"

find "${DEPS_DIR}" -type d -name "__pycache__" -prune -exec rm -rf {} +

cd "${DEPS_DIR}"
zip -r -q "${DEPS_ZIP}" python
ls -lh "${DEPS_ZIP}"
