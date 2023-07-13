#!/bin/sh

DIR=$(pwd)

if [[ -z $1 ]]; then
    echo "Please provide the component to apply (common_infra/lambda_layers/frontend/backend)"
    exit 1
fi

COMPONENT=$1

if [[ $COMPONENT = "common_infra" ]]; then
    ENV_FILE="$DIR/.env"

    SECRETS=$(grep 'DATABASE_URL\|API_KEY' $ENV_FILE | grep -v '^#')

    echo "Extracting secret tokens from .env and export them to TF_VAR ..."
    for SECRET in $SECRETS; do
        KEY=${SECRET%%=*}
        NEW_KEY=$(echo $KEY | tr '[:upper:]' '[:lower:]' | sed -e 's/^/TF_VAR_/')
        VALUE=$(echo $SECRET | sed 's/^[^"]*"\([^"]*\)".*/\1/')
        export $NEW_KEY="$VALUE"
        echo "$NEW_KEY is exported"

    done
fi

if [[ $2 = "destroy" ]]; then
    echo "This is a DESTROY action..."
    PLAN="-destroy"
else
    echo "This is a DEPLOY action..."
    PLAN=""
fi

ENVIRONMENT="dev"
PROJECT="posts"
REGION="cn-north-1"

DEPLOYMENT_FOLDER="$DIR/terraform/deployment/$COMPONENT"
ENVIRONMENTS_FOLDER="$DIR/terraform/settings/$ENVIRONMENT"

pushd $DEPLOYMENT_FOLDER || exit

cd $DIR/terraform/deployment/$COMPONENT
terraform init -reconfigure \
    -backend-config="$ENVIRONMENTS_FOLDER/backend.config" \
    -backend-config="key=$PROJECT/$ENVIRONMENT/$REGION/$COMPONENT.tfstate"
terraform plan $PLAN -var-file ../../settings/${ENVIRONMENT}/variables.tfvars -out tfplan -lock=true
terraform apply tfplan

popd || exit
