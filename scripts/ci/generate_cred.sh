#!/bin/bash
set -e -o pipefail

AWS_PROFILE=$1

CRED_DIR="$WORKSPACE/.aws"

[ ! -d "$CRED_DIR" ] && mkdir -p "$CRED_DIR"

cat >$CRED_DIR/credentials <<EOF
[$AWS_PROFILE]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
EOF
