data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

# IAM Role
resource "aws_iam_role" "role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = var.assume_role_policy != null ? var.assume_role_policy : data.aws_iam_policy_document.assume_role_policy.json

  tags = var.tags
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
  for_each = var.aws_managed_policy_arns

  role       = aws_iam_role.role.name
  policy_arn = each.key
}

# IAM Customized Policy
resource "aws_iam_policy" "customized_policy" {
  for_each = var.user_managed_policies

  name   = "${var.role_name}-${each.key}"
  policy = each.value

  tags = var.tags
}

# IAM Customized Policy Attachment
resource "aws_iam_role_policy_attachment" "customized_policy_attachment" {
  for_each = aws_iam_policy.customized_policy

  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "role_profile" {
  count = var.has_iam_instance_profile ? 1 : 0

  name = aws_iam_role.role.name
  role = aws_iam_role.role.name

  tags = var.tags
}
