#
# Outputs
#

output "curl_stage_invoke_url" {
  description = "URL to invoke the API pointing to the stage"
  value       = "curl ${aws_api_gateway_stage.rest_api.invoke_url}"
}

output "id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "arn" {
  value = aws_api_gateway_rest_api.rest_api.execution_arn
}
