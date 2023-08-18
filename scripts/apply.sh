#!/bin/sh

DIR=$(pwd)
set +e

if [[ -z $1 ]]; then
    echo "Please provide the component to apply (common_infra/lambda_layers/frontend/backend)"
    exit 1
fi

COMPONENT=$1
ENVIRONMENT="dev"
PROJECT="petstore"
AWS_REGION="cn-north-1"

if [[ $COMPONENT = "common_infra" ]]; then
    ENV_FILE="$DIR/.env"

    SECRETS=$(grep 'DATABASE_URL\|API_KEY\|STMP_PASS' $ENV_FILE | grep -v '^#')

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

DEPLOYMENT_FOLDER="$DIR/terraform/deployment/$COMPONENT"
ENVIRONMENTS_FOLDER="$DIR/terraform/settings/$ENVIRONMENT"
MIRROR_FOLDER="$DIR/.terraform/providers"

pushd $DEPLOYMENT_FOLDER || exit

cd $DIR/terraform/deployment/$COMPONENT

terraform providers mirror $MIRROR_FOLDER

terraform init -reconfigure \
    -backend-config="$ENVIRONMENTS_FOLDER/backend.config" \
    -backend-config="key=$PROJECT/$ENVIRONMENT/$REGION/$COMPONENT.tfstate" \
    --plugin-dir $MIRROR_FOLDER
terraform plan $PLAN -var-file ../../settings/${ENVIRONMENT}/variables.tfvars -out tfplan -lock=true
terraform apply tfplan

popd || exit
