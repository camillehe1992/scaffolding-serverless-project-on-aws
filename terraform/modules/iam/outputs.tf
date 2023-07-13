output "lambda_role" {
  value = {
    id  = aws_iam_role.lambda_role.id
    arn = aws_iam_role.lambda_role.arn
  }
}

output "api_gateway_role" {
  value = length(aws_iam_role.api_gateway_role) > 0 ? {
    id  = aws_iam_role.api_gateway_role[0].id
    arn = aws_iam_role.api_gateway_role[0].arn
  } : null
}
