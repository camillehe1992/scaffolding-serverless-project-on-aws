module "api_gateway" {
  source = "../../modules/api_gateway"
  tags   = var.tags

  rest_api_name     = "${var.environment}-${var.nickname}-portal"
  endpoint_type     = "REGIONAL"
  swagger_file      = "swagger.yaml"
  invoke_arn        = module.portal_function.function.invoke_arn
  retention_in_days = var.retention_in_days
}

module "portal_function" {
  source = "../../modules/lambda_function"
  tags   = var.tags

  function_name     = "${var.environment}-${var.nickname}-portal"
  description       = "The portal function that invoked by API Gateway"
  role_arn          = data.terraform_remote_state.common_infra.outputs.lambda_execution_role_arn
  handler           = "app.main.lambda_handler"
  retention_in_days = var.retention_in_days
  runtime           = var.runtime
  architecture      = var.architecture
  source_dir        = "../../../src/portal"
  output_path       = "build/portal.zip"

  layers = [
    data.terraform_remote_state.common_infra.outputs.dependencies_layer_arn,
    local.aws_lambda_powertools_lambda_layer_arn
  ]
  environment_variables = merge(local.default_environment_variables, {})

  lambda_permissions = {
    allow-apigateway-invocation = {
      principal  = "apigateway.amazonaws.com"
      source_arn = "${module.api_gateway.rest_api.execution_arn}/*/*"
    }
  }
}
