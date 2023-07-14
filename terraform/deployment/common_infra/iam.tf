module "iam" {
  source      = "../../modules/iam"
  tags        = var.tags
  environment = var.environment
  nickname    = var.nickname

  lambda_role_name        = var.lambda_role_name
  lambda_role_description = var.lambda_role_description
  lambda_policy_name      = var.lambda_policy_name
  lambda_policy_attachment_arns = [
    "arn:aws-cn:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  ]

  api_gateway_role_deployment  = var.api_gateway_role_deployment
  api_gateway_role_name        = [var.api_gateway_role_name]
  api_gateway_role_description = [var.api_gateway_role_description]
  api_gateway_policy_name      = var.api_gateway_policy_name
  api_gateway_policy_attachment_arns = [
    "arn:aws-cn:iam::aws:policy/AWSXrayWriteOnlyAccess",
    "arn:aws-cn:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}
