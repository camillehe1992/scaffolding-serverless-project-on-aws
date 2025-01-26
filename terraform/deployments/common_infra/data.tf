data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_iam_policy_document" "customized" {
  statement {
    sid = "AllowDynamodb"
    actions = [
      "dynamodb:*"
    ]
    resources = ["*"]
  }
}
