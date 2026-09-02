#!/usr/bin/env bash
set -euo pipefail

cache_build_dir=".terragrunt-cache/.build"
mkdir -p "$cache_build_dir"
cp "${GITHUB_WORKSPACE}/${DEPENDENCIES_LAYER_FILE}" "${cache_build_dir}/dependencies.zip"
