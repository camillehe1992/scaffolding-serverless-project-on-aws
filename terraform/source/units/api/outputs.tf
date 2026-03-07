# API Gateway
output "api_gateway_rest_api" {
  description = "The API Gateway REST API"
  value = {
    arn              = module.api_gateway.rest_api.arn
    cw_log_group_arn = module.api_gateway.cw_log_group_arn
  }
}

output "invoke_url" {
  description = "The invoke URL of the API Gateway REST API"
  value       = module.api_gateway.stage.invoke_url
}

output "swagger_url" {
  description = "The Swagger URL of the API Gateway REST API"
  value       = "${module.api_gateway.stage.invoke_url}/swagger"
}

output "function" {
  description = "The ARN of the portal function"
  value = {
    arn              = module.portal_function.function.arn
    cw_log_group_arn = module.portal_function.cw_log_group_arn
  }
}

output "dependencies_layer_arn" {
  description = "The ARN of the Lambda layer that contains the dependencies"
  value       = aws_lambda_layer_version.this.arn
}
