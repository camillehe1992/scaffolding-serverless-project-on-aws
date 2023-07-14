#!/bin/sh

DIR=$(pwd)

if [[ -z $1 ]]; then
    echo "Please provide the component to apply (common_infra/lambda_layers/frontend/backend)"
    exit 1
fi

COMPONENT=$1
ENVIRONMENT=$2
NICKNAME=$3
REGION="cn-north-1"

DEPLOYMENT_FOLDER="$DIR/terraform/deployment/$COMPONENT"
ENVIRONMENTS_FOLDER="$DIR/terraform/settings/$ENVIRONMENT"

pushd $DEPLOYMENT_FOLDER || exit

cd $DIR/terraform/deployment/$COMPONENT
terraform init -reconfigure \
    -backend-config="$ENVIRONMENTS_FOLDER/backend.config" \
    -backend-config="key=$NICKNAME/$ENVIRONMENT/$REGION/$COMPONENT.tfstate"
terraform plan -destroy -var-file ../../settings/${ENVIRONMENT}/variables.tfvars -out tfplan -lock=true
terraform apply tfplan

popd || exit
