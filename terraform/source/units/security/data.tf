data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    sid = "AllowDynamodb"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
    resources = [
      "arn:${local.aws_partition}:dynamodb:${local.aws_region}:${local.aws_account_id}:table/${local.resource_prefix}-*"
    ]
  }
}
