# API Gateway
module "api_gateway" {
  source = "../../modules/api_gateway"

  rest_api_name     = "${local.resource_prefix}-portal"
  endpoint_type     = "REGIONAL"
  swagger_file      = "swagger.yaml"
  invoke_arn        = module.portal_function.function.invoke_arn
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}
