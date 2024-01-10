output "curl_stage_invoke_url" {
  value       = "curl ${aws_api_gateway_stage.this.invoke_url}"
  description = "URL to invoke the API pointing to the stage"
}

output "api_gateway_rest_api" {
  value = aws_api_gateway_rest_api.this
}
