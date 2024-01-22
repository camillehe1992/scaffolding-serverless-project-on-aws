#!/bin/bash

set -e -o pipefail
DIR=$(pwd)
echo $DIR

MODULES_DIR=$DIR/terraform/modules/*/
TF_DOCS_CONFIG=$DIR/terraform/modules/.terraform-docs.yaml

for DIR in $MODULES_DIR; do
    terraform-docs -c $TF_DOCS_CONFIG $DIR >$DIR/README.md
    echo "Sync $DIR/README.md"
done
