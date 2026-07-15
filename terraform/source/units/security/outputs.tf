# IAM Roles and Policies
output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = module.lambda_execution_role.role_arn
}
