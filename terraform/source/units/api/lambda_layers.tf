# Lambda Layer Version that contains external dependencies
data "external" "dependencies_zip_build" {
  program = [
    "bash",
    var.dependencies_layer_build_script_path,
    var.dependencies_layer_file_path
  ]
}

data "local_file" "dependencies_zip_file" {
  filename = data.external.dependencies_zip_build.result.filename
}

resource "aws_lambda_layer_version" "this" {
  layer_name               = "${local.resource_prefix}-dependencies"
  description              = "External dependencies for Lambda function"
  compatible_architectures = [var.architecture]
  compatible_runtimes      = [var.lambda_runtime]
  filename                 = data.local_file.dependencies_zip_file.filename
  source_code_hash         = data.local_file.dependencies_zip_file.content_base64sha256
}
