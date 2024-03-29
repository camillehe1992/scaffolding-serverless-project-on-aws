# module "api_gateway_vpc_endpoint" {
#   source = "../../modules/vpc_endpoint"

#   tags                                = var.tags
#   api_gateway_vpc_endpoint_deployment = var.api_gateway_vpc_endpoint_deployment
#   vpc_id                              = var.vpc_id
#   subnet_ids                          = var.subnet_ids
#   security_group_ids                  = var.security_group_ids
# }

module "api_gateway" {
  source = "../../modules/api_gateway"
  # depends_on = [module.api_gateway_vpc_endpoint]

  environment  = var.environment
  nickname     = var.nickname
  tags         = var.tags
  swagger_file = var.swagger_file
  invoke_arn   = module.portal_function.function.invoke_arn
  # vpc_endpoint_id   = module.api_gateway_vpc_endpoint.interface_endpoint.id
}
