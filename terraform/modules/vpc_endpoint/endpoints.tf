resource "aws_vpc_endpoint" "private_api_gateway" {
  count = var.api_gateway_vpc_endpoint_deployment ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "cn.com.amazonaws.${var.aws_region}.execute-api"
  vpc_endpoint_type = "Interface"

  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = var.tags
}
