output "function" {
  value = aws_lambda_function.this
}

output "cw_logs_group" {
  value = aws_cloudwatch_log_group.this
}
