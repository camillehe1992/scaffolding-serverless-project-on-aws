# IAM Roles and Policies
output "lambda_execution_role_arn" {
  value = module.lambda_execution_role.iam_role.arn
}

# Lambda Layers
output "dependencies_layer_arn" {
  value = module.dependencies_layer.layer.arn
}
