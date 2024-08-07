module "lambda_execution_role" {
  source           = "../../modules/iam"
  tags             = var.tags
  resource_prefix  = "${var.environment}-${var.nickname}-"
  role_name        = "lambda-exection-role"
  role_description = "The IAM role that grants the function permission to access AWS services and resources"
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  customized_policies = {
    "allow-dynamodb-actions" = data.aws_iam_policy_document.allow-dynamodb.json
  }
}
