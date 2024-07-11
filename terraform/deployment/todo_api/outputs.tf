# IAM Roles and Policies
output "lambda_execution_role_arn" {
  value = module.lambda_execution_role.iam_role.arn
}

output "api_gateway_logging_role_arn" {
  value = module.api_gateway_logging_role.iam_role.arn
}

# Lambda Layers
output "dependencies_layer" {
  value = {
    arn = module.dependencies_layer.layer.arn
  }
}

# API Gateway
output "api_gateway_rest_api" {
  value = {
    arn        = module.api_gateway.rest_api.arn
    invoke_url = module.api_gateway.stage.invoke_url
  }
}

# Lambda Functions
output "lambda_function" {
  value = {
    arn = module.portal_function.function.arn
  }
}
