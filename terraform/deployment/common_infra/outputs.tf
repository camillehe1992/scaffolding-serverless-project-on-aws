output "lambda_role" {
  value = module.iam.lambda_role
}

output "api_gateway_role" {
  value = module.iam.api_gateway_role
}
