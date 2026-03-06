module "api_gateway" {
  source = "../../modules/api_gateway"

  rest_api_name     = "${local.resource_prefix}-portal"
  endpoint_type     = "REGIONAL"
  swagger_file      = "swagger.yaml"
  invoke_arn        = module.portal_function.function.invoke_arn
  retention_in_days = var.retention_in_days

  tags = var.tags
}

module "portal_function" {
  source = "../../modules/lambda_function"

  function_name     = "${local.resource_prefix}-portal"
  description       = "The portal function that invoked by API Gateway"
  role_arn          = var.role_arn
  handler           = var.handler
  retention_in_days = var.retention_in_days
  runtime           = var.runtime
  architecture      = var.architecture
  source_dir        = var.source_dir
  output_path       = var.output_path

  layers = [
    var.dependencies_layer_arn,
    local.aws_lambda_powertools_lambda_layer_arn
  ]
  environment_variables = merge(local.default_environment_variables, {})

  lambda_permissions = {
    allow-apigateway-invocation = {
      principal  = "apigateway.amazonaws.com"
      source_arn = "${module.api_gateway.rest_api.execution_arn}/*/*"
    }
  }
  tags = var.tags
}
