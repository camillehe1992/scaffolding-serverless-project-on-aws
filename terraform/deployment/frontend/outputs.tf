# API Gateway
output "curl_stage_invoke_url" {
  value = module.api_gateway.curl_stage_invoke_url
}

# Lambda Functions
output "lambda_functions" {
  value = module.lambda_functions.functions
}

output "lambda_function_log_group" {
  value = module.lambda_functions.lambda_log_groups
}
