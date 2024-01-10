output "function" {
  value = {
    arn          = aws_lambda_function.this.arn
    cwlogs_group = aws_cloudwatch_log_group.this.arn
  }
}
