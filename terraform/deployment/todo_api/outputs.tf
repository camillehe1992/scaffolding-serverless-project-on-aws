# IAM Roles and Policies
output "lambda_execution_role" {
  value = module.lambda_execution_role.iam_role
}

output "api_gateway_logging_role" {
  value = module.api_gateway_logging_role.iam_role
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
output "curl_stage_invoke_url" {
  value = module.api_gateway.curl_stage_invoke_url
}

# Lambda Functions
output "lambda_function" {
  value = module.portal_function.function
}
