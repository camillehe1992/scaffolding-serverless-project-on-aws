#!/bin/bash
set -e -o pipefail

PWD=$(pwd)

COMPONENT=$1

DIR="/app"

WORKING_DIR="$DIR/terraform/deployment/$COMPONENT"

docker run --rm \
    -v $PWD:$DIR \
    -v $HOME/.aws/credentials:/root/.aws/credentials \
    -w $WORKING_DIR \
    $TF_IMAGE \
    apply tfplan -no-color

exit 0
