module "api_gateway" {
  source = "../../modules/api_gateway"

  resource_prefix = "${var.environment}-${var.nickname}-"
  tags            = var.tags

  endpoint_type = "REGIONAL"
  swagger_file  = var.swagger_file
  invoke_arn    = module.portal_function.function.invoke_arn
}
