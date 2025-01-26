resource "aws_iam_role" "this" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each = var.aws_managed_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.key
}

resource "aws_iam_policy" "customized" {
  name   = "${aws_iam_role.this.name}-customized"
  policy = var.customized_policy_json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "customized" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.customized.arn
}

resource "aws_iam_instance_profile" "this" {
  count = var.enable_iam_instance_profile ? 1 : 0
  name  = aws_iam_role.this.name
  role  = aws_iam_role.this.name
}
