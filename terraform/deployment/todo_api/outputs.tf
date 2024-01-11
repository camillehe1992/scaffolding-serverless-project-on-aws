# IAM Roles and Policies
output "lambda_execution_role" {
  value = {
    arn = module.lambda_execution_role.iam_role.arn
  }
}

output "api_gateway_logging_role" {
  value = {
    arn = module.api_gateway_logging_role.iam_role.arn
  }
}

# Lambda Layers
output "dependencies_layer" {
  value = {
    arn        = module.dependencies_layer.layer.arn
    layer_name = module.dependencies_layer.layer.layer_name
    version    = module.dependencies_layer.layer.version
  }
}

# API Gateway
output "api_gateway_rest_api" {
  value = {
    arn           = module.api_gateway.rest_api.arn
    execution_arn = module.api_gateway.rest_api.execution_arn
    id            = module.api_gateway.rest_api.id
    invoke_url    = module.api_gateway.stage.invoke_url
  }
}

# Lambda Functions
output "lambda_function" {
  value = {
    arn           = module.portal_function.function.arn
    function_name = module.portal_function.function.function_name
    invoke_arn    = module.portal_function.function.invoke_arn
  }
}
