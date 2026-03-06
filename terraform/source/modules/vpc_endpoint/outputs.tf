output "interface_endpoint" {
  value = length(aws_vpc_endpoint.private_api_gateway) > 0 ? {
    id  = aws_vpc_endpoint.private_api_gateway[0].id
    arn = aws_vpc_endpoint.private_api_gateway[0].arn
  } : null
}
