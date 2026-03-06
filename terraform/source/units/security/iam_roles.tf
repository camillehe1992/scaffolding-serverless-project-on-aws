
# Lambda Execution Role
module "lambda_execution_role" {
  source = "../../modules/iam_role"

  role_name        = "${local.resource_prefix}-lambda-exection-role"
  role_description = "The execution role grants the Lambda function permission to make AWS API calls"
  principals = {
    "Service" = {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
  aws_managed_policy_arns = [
    "arn:${local.aws_partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  user_managed_policies = {
    "dynamodb-policy" = data.aws_iam_policy_document.dynamodb_policy.json
  }
  tags = var.tags
}

data "local_file" "dependencies_zip_file" {
  filename = var.filename
}

resource "aws_lambda_layer_version" "this" {
  layer_name               = "${local.resource_prefix}-dependencies"
  description              = "External dependencies that install via pip"
  compatible_architectures = [var.architecture]
  compatible_runtimes      = [var.runtime]
  filename                 = data.local_file.dependencies_zip_file.filename
  source_code_hash         = data.local_file.dependencies_zip_file.content_base64sha256
}
