
module "api_gateway_vpc_endpoint" {
  source = "../../modules/vpc_endpoint"

  api_gateway_vpc_endpoint_deployment = var.api_gateway_vpc_endpoint_deployment
  vpc_id                              = var.vpc_id
  subnet_ids                          = var.subnet_ids
  security_group_ids                  = var.security_group_ids
  tags                                = var.tags
}
