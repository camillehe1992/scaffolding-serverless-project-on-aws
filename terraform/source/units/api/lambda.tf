# Lambda Layer Version that contains external dependencies
data "local_file" "dependencies_zip_file" {
  filename = var.dependencies_layer_file_path
}

resource "aws_lambda_layer_version" "this" {
  layer_name               = "${local.resource_prefix}-dependencies"
  description              = "External dependencies for Lambda function"
  compatible_architectures = [var.architecture]
  compatible_runtimes      = [var.lambda_runtime]
  filename                 = data.local_file.dependencies_zip_file.filename
  source_code_hash         = data.local_file.dependencies_zip_file.content_base64sha256
}

# Lambda Function that invoked by API Gateway
module "portal_function" {
  source = "../../modules/lambda_function"

  function_name     = "${local.resource_prefix}-portal"
  description       = "The portal function that invoked by API Gateway"
  role_arn          = var.role_arn
  handler           = var.handler
  retention_in_days = var.log_retention_in_days
  runtime           = var.lambda_runtime
  architecture      = var.architecture
  source_dir        = var.source_dir
  output_path       = var.output_path
  layers = [
    local.aws_lambda_powertools_lambda_layer_arn,
    aws_lambda_layer_version.this.arn
  ]
  environment_variables = var.lambda_environment_variables

  lambda_permissions = {
    allow-apigateway-invocation = {
      principal  = "apigateway.amazonaws.com"
      source_arn = "${module.api_gateway.rest_api.execution_arn}/*/*"
    }
  }
  tags = var.tags
}
