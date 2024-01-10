output "rest_api" {
  value = aws_api_gateway_rest_api.this
}

output "cw_logs_group" {
  value = aws_cloudwatch_log_group.this
}
