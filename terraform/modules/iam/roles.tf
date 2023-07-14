resource "aws_iam_role" "lambda_role" {
  name        = "${local.resource_prefix}${var.lambda_role_name}"
  description = var.lambda_role_description

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role" "api_gateway_role" {
  count       = var.api_gateway_role_deployment ? 1 : 0
  name        = "${local.resource_prefix}${var.api_gateway_role_name[count.index]}"
  description = var.api_gateway_role_description[count.index]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      }
    }
  ]
}
EOF

  tags = var.tags
}
