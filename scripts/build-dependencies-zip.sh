#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)

DEFAULT_BUILD_DIR="${PROJECT_ROOT}/.build"
DEPS_ZIP="${1:-${DEFAULT_BUILD_DIR}/dependencies.zip}"
case "${DEPS_ZIP}" in
    /*) ;;
    *) DEPS_ZIP="${PWD}/${DEPS_ZIP}" ;;
esac
BUILD_DIR=$(dirname "${DEPS_ZIP}")
DEPS_DIR="${BUILD_DIR}/dependencies"
REQ_FILE="${PROJECT_ROOT}/src/requirements.txt"
REQ_HASH_FILE="${DEPS_ZIP}.requirements.sha256"

requirements_hash() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "${REQ_FILE}" | awk '{print $1}'
    elif command -v openssl >/dev/null 2>&1; then
        openssl dgst -sha256 -r "${REQ_FILE}" | awk '{print $1}'
    else
        shasum -a 256 "${REQ_FILE}" | awk '{print $1}'
    fi
}

zip_is_valid() {
    [ -f "${DEPS_ZIP}" ] && zip -T "${DEPS_ZIP}" >&2
}

emit_result() {
    printf '{"filename":"%s"}\n' "${DEPS_ZIP}"
}

current_req_hash=$(requirements_hash)
stored_req_hash=""

if [ -f "${REQ_HASH_FILE}" ]; then
    stored_req_hash=$(cat "${REQ_HASH_FILE}")
fi

if [ "${stored_req_hash}" = "${current_req_hash}" ] && zip_is_valid; then
    echo "[*] Reuse valid dependencies zip for unchanged ${REQ_FILE}" >&2
    emit_result
    exit 0
fi

if [ -f "${DEPS_ZIP}" ]; then
    if [ "${stored_req_hash}" != "${current_req_hash}" ]; then
        echo "[*] Requirements changed; rebuild dependencies zip" >&2
    else
        echo "[*] Existing dependencies zip is invalid; rebuild dependencies zip" >&2
    fi
else
    echo "[*] Dependencies zip does not exist; build dependencies zip" >&2
fi

echo "[*] Build dependencies zip from ${REQ_FILE} into ${DEPS_ZIP}" >&2

rm -rf "${DEPS_DIR}"
rm -f "${DEPS_ZIP}"
mkdir -p "${DEPS_DIR}/python"

PYTHONDONTWRITEBYTECODE=1 python3 -m pip install \
    --no-cache-dir \
    -r "${REQ_FILE}" \
    -t "${DEPS_DIR}/python" >&2

find "${DEPS_DIR}" -type d -name "__pycache__" -prune -exec rm -rf {} +

cd "${DEPS_DIR}"
zip -r -q "${DEPS_ZIP}" python
zip -T "${DEPS_ZIP}" >&2
ls -lh "${DEPS_ZIP}" >&2
printf '%s\n' "${current_req_hash}" >"${REQ_HASH_FILE}"

emit_result
