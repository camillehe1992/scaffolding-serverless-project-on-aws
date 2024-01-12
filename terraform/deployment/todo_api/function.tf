module "portal_function" {
  source = "../../modules/lambda_function"

  environment = var.environment
  nickname    = var.nickname
  tags        = var.tags

  function_name = "portal"
  description   = "The portal function that invoked by API Gateway"
  role_arn      = module.lambda_execution_role.iam_role.arn
  handler       = "app.main.lambda_handler"
  memory_size   = var.lambda_function_memory_size
  timeout       = var.lambda_function_timeout
  runtime       = var.lambda_function_runtime
  architecture  = var.architecture
  source_dir    = "../../../src/portal"
  output_path   = "build/portal.zip"

  layers = [
    module.dependencies_layer.layer.arn
  ]
  environment_variables = {
    POWERTOOLS_SERVICE_NAME = var.nickname
    POWERTOOLS_LOG_LEVEL    = var.log_level
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
