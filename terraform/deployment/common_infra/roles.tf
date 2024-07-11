module "lambda_execution_role" {
  source           = "../../modules/iam"
  tags             = var.tags
  resource_prefix  = "${var.environment}-${var.nickname}-"
  role_name        = "lambda-exection-role"
  role_description = "The IAM role that grants the function permission to access AWS services and resources"
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaENIManagementAccess",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

module "api_gateway_logging_role" {
  source                         = "../../modules/iam"
  tags                           = var.tags
  role_name                      = "AmazonAPIGatewayPushToCloudWatchLogs"
  assume_role_policy_identifiers = ["apigateway.amazonaws.com"]
  role_description               = "The IAM role that grant API Gateway permission to read and write logs to CloudWatch"
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  ]
}
