resource "aws_api_gateway_rest_api" "this" {
  body = templatefile(var.swagger_file, {
    invoke_arn = var.invoke_arn
  })

  name        = "${var.resource_prefix}${var.name}"
  description = var.description
  tags        = var.tags

  endpoint_configuration {
    types = [var.endpoint_type]
  }
  policy = data.aws_iam_policy_document.this.json
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
  retention_in_days = var.log_retention_days

  tags = var.tags
}
