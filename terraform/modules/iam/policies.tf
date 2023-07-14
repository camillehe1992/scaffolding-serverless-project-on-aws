resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.resource_prefix}${var.lambda_policy_name}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CommonActions",
          "Effect" : "Allow",
          "Action" : [
            "cognito-idp:ListUsers",
            "firehose:PutRecord",
            "kms:*",
            "ssm:*",
            "s3:*",
            "ses:SendEmail",
            "sns:Publish",
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords",
            "ec2:DescribeRegions",
            "events:PutEvents",
            "lambda:InvokeFunction",
            "logs:Describe*",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents",
            "sts:AssumeRole",
            "sts:GetCallerIdentity",
            "cloudwatch:PutMetricData",
            "secretsmanager:GetSecretValue"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "ApiKeyActions",
          "Effect" : "Allow",
          "Action" : [
            "apigateway:POST",
            "apigateway:GET",
            "apigateway:DELETE",
            "apigateway:PUT",
            "apigateway:PATCH"
          ],
          "Resource" : [
            "arn:aws-cn:apigateway:*::/apikeys",
            "arn:aws-cn:apigateway:*::/apikeys/*",
            "arn:aws-cn:apigateway:*::/usageplans/*",
            "arn:aws-cn:apigateway:*::/usageplans",
            "arn:aws-cn:apigateway:*::/restapis/*/resources"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "cloudwatch" {
  count = var.api_gateway_role_deployment ? 1 : 0

  name = "${local.resource_prefix}${var.api_gateway_policy_name}"
  role = aws_iam_role.api_gateway_role[0].id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
