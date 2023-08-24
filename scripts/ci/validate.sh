#!/bin/bash
set -e -o pipefail

PWD=$(pwd)

WORKSPACE="/app"

docker run --rm \
    -v $PWD:$WORKSPACE \
    $TF_IMAGE \
    fmt -check -diff -recursive /app/terraform -no-color

docker run --rm \
    -v $PWD:$WORKSPACE \
    $TF_IMAGE \
    validate -no-color

exit 0
