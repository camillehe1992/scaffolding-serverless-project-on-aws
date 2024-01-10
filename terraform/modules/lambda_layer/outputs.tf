output "layer" {
  value       = one(var.from_local ? aws_lambda_layer_version.from_local[*] : aws_lambda_layer_version.from_s3[*])
  description = "Lambda layer attributes"
}
