module "portal_function" {
  source = "../../modules/lambda_function"

  resource_prefix = "${var.environment}-${var.nickname}-"
  tags            = var.tags

  function_name = "portal"
  description   = "The portal function that invoked by API Gateway"
  role_arn      = data.terraform_remote_state.common_infra.outputs.lambda_execution_role_arn
  handler       = "app.main.lambda_handler"
  memory_size   = var.lambda_function_memory_size
  timeout       = var.lambda_function_timeout
  runtime       = var.lambda_function_runtime
  architecture  = var.architecture
  source_dir    = "../../../src/portal"
  output_path   = "build/portal.zip"

  layers = [
    data.terraform_remote_state.common_infra.outputs.dependencies_layer_arn,
    local.aws_lambda_powertools_lambda_layer_arn
  ]
  environment_variables = {
    APP_VERSION             = var.app_version
    ENVIRONMENT             = var.environment
    LOG_LEVEL               = var.log_level
    NICKNAME                = var.nickname
    POWERTOOLS_LOG_LEVEL    = var.log_level
    POWERTOOLS_SERVICE_NAME = var.nickname
  }
  subnet_ids         = []
  security_group_ids = []

  retention_in_days = var.log_retention_days

  lambda_permissions = {
    allow-apigateway-invocation = {
      principal  = "apigateway.amazonaws.com"
      source_arn = "${module.api_gateway.rest_api.execution_arn}/*/*"
    }
  }
}
