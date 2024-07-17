
data "aws_partition" "current" {}

data "aws_iam_policy_document" "allow-dynamodb" {
  statement {
    sid = "AllowDynamodb"
    actions = [
      "dynamodb:*"
    ]
    resources = ["*"]
  }
}
