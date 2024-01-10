data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "local_file" "openapi_spec" {
  filename = var.openapi_json_file
}

resource "aws_api_gateway_rest_api" "this" {
  body = templatefile(var.openapi_json_file, {
    function_name = var.function_name
  })

  name        = "${local.resource_prefix}${var.rest_api_name}"
  description = var.rest_api_description
  tags        = var.tags

  endpoint_configuration {
    types = ["REGIONAL"]
    # vpc_endpoint_ids = [var.vpc_endpoint_id]
  }
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "execute-api:Invoke",
          "Resource": "arn:${data.aws_partition.current.partition}:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      }
  ]
}
EOF
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(aws_api_gateway_rest_api.this.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.id}/${var.stage_name}"
  retention_in_days = var.api_gateway_log_retention_days

  tags = var.tags
}
