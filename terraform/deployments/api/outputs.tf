# API Gateway
output "api_gateway_rest_api" {
  value = {
    arn         = module.api_gateway.rest_api.arn
    invoke_url  = module.api_gateway.stage.invoke_url
    swagger_url = "${module.api_gateway.stage.invoke_url}/swagger"
  }
}

# Lambda Functions
output "lambda_function" {
  value = {
    arn = module.portal_function.function.arn
  }
}
