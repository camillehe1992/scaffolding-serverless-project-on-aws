data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    sid = "AllowDynamodb"
    actions = [
      "dynamodb:*"
    ]
    resources = ["*"]
  }
}
