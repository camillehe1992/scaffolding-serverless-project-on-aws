# Lambda Layer Version that contains external dependencies
data "local_file" "dependencies_zip_file" {
  filename = var.dependencies_layer_file_path
}

resource "aws_lambda_layer_version" "this" {
  layer_name               = "${local.resource_prefix}-dependencies"
  description              = "External dependencies for Lambda function"
  compatible_architectures = [var.architecture]
  compatible_runtimes      = [var.lambda_runtime]
  filename                 = data.local_file.dependencies_zip_file.filename
  source_code_hash         = data.local_file.dependencies_zip_file.content_base64sha256
}
