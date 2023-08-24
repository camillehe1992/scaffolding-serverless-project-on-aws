#
# Stage and Stage Settings
#

resource "aws_api_gateway_stage" "rest_api" {
  deployment_id = aws_api_gateway_deployment.rest_api.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_method_settings" "rest_api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.rest_api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}
