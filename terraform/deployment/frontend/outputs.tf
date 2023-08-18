# API Gateway

output "curl_stage_invoke_url" {
  value = module.api_gateway.curl_stage_invoke_url
}
# output "api_gateway" {
#   value = {
#     id  = module.api_gateway.id
#     arn = module.api_gateway.arn
#   }
# }

# output "api_gateway_deployment" {
#   value = module.api_gateway.deployment.invoke_url
# }

# output "api_gateway_stage" {
#   value = module.api_gateway.stage.name
# }

# output "api_gateway_resources" {
#   value = module.api_gateway.resources
# }

# output "api_gateway_methods" {
#   value = module.api_gateway.methods
# }

# output "api_gateway_methods_responses" {
#   value = module.api_gateway.methods_responses
# }

# output "api_gateway_integrations_responses" {
#   value = module.api_gateway.integrations_responses
# }

# output "api_gateway_integrations" {
#   value = module.api_gateway.integrations
# }

# output "frontend_access_logs_group" {
#   value = module.api_gateway.access_logs_group
# }

# output "frontend_gateway_logs_group" {
#   value = module.api_gateway.gateway_logs_group
# }
# Lambda Functions

output "lambda_functions" {
  value = module.lambda_functions.functions
}

output "frontend_lambda_log_group" {
  value = module.lambda_functions.lambda_log_group
}
