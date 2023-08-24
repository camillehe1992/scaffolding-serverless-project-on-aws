#!/bin/bash
set -e -o pipefail

PWD=$(pwd)

COMPONENT=$1
ENVIRONMENT=$2

DIR="/app"
WORKING_DIR="$DIR/terraform/deployment/$COMPONENT"

docker run --rm \
    -v $PWD:$DIR \
    -v $HOME/.aws/credentials:/root/.aws/credentials \
    -w $WORKING_DIR \
    $TF_IMAGE \
    init -reconfigure \
    -backend-config="$DIR/terraform/settings/$ENVIRONMENT/backend.config" \
    -backend-config="key=$NICKNAME/$ENVIRONMENT/$AWS_REGION/$COMPONENT.tfstate" \
    -upgrade \
    -plugin-dir "../../../../.terraform.d/plugin-cache" \
    -no-color

exit 0
