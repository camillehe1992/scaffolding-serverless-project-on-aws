data "local_file" "openapi_spec" {
  filename = var.openapi_json_file
}
data "aws_caller_identity" "current" {}


resource "aws_api_gateway_rest_api" "rest_api" {
  body = templatefile(var.openapi_json_file, {
    function_name = "${var.environment}-${var.nickname}-frontend"
  })

  name        = "${local.resource_prefix}${var.rest_api_name}"
  description = var.rest_api_description
  tags        = var.tags

  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.vpc_endpoint_id]
  }
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "execute-api:Invoke",
          "Resource": "arn:aws-cn:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
      }
  ]
}
EOF
}

resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(aws_api_gateway_rest_api.rest_api.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "gateway_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.rest_api.id}/${var.stage_name}"
  retention_in_days = var.api_gateway_log_retention_days

  tags = var.tags
}
