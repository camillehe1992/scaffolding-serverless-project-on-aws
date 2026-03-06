# IAM Roles and Policies
output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = module.lambda_execution_role.role_arn
}

output "dependencies_layer_arn" {
  description = "The ARN of the Lambda layer that contains the dependencies"
  value       = aws_lambda_layer_version.this.arn
}
