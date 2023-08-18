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
    plan -var-file $DIR/terraform/settings/$ENVIRONMENT/variables.tfvars \
    -out tfplan -no-color

exit 0
