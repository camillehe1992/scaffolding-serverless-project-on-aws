output "function" {
  description = "The Lambda function"
  value       = aws_lambda_function.this
}

output "cw_log_group_arn" {
  description = "The ARN of the CloudWatch Logs group for the Lambda function"
  value       = aws_cloudwatch_log_group.this.arn
}
