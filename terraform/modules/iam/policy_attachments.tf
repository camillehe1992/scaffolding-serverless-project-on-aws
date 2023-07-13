resource "aws_iam_role_policy_attachment" "lambda_policy_attachments" {
  count = length(var.lambda_policy_attachment_arns)

  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_policy_attachment_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy_attachments" {
  count = var.api_gateway_role_deployment ? length(var.api_gateway_policy_attachment_arns) : 0

  role       = aws_iam_role.api_gateway_role[0].name
  policy_arn = var.api_gateway_policy_attachment_arns[count.index]
}
