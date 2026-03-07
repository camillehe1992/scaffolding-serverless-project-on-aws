output "rest_api" {
  description = "The API Gateway REST API"
  value       = aws_api_gateway_rest_api.this
}

output "stage" {
  description = "The API Gateway stage"
  value       = aws_api_gateway_stage.this
}

output "cw_log_group_arn" {
  description = "The ARN of the CloudWatch Logs group for the API Gateway"
  value       = aws_cloudwatch_log_group.this.arn
}
