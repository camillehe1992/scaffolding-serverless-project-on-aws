data "archive_file" "lambda_layers_code" {
  for_each = var.lambda_layers_local

  type        = "zip"
  source_dir  = each.value["source_dir_path"]
  output_path = each.value["output_file_path"]
}

data "aws_lambda_layer_version" "remote" {
  for_each = var.lambda_layers_remote

  layer_name = "${local.resource_prefix}${each.key}"
  version    = each.value["version"]
}

resource "aws_lambda_layer_version" "local" {
  for_each = var.lambda_layers_local

  layer_name          = "${local.resource_prefix}${each.key}"
  description         = each.value["description"]
  filename            = each.value["output_file_path"]
  source_code_hash    = data.archive_file.lambda_layers_code[each.key].output_base64sha256
  compatible_runtimes = var.runtimes
}

# For deployment package (.zip file archive) with size more than 50 MB (zipped, for direct upload)
# This quota applies to all the files you upload, including layers and custom runtimes.
# 3 MB (console editor). upload zip file to s3 then create lambda layer
resource "aws_s3_object" "file_upload" {
  depends_on = [data.archive_file.lambda_layers_code]
  for_each   = var.lambda_layers_dependencies

  bucket      = var.s3_bucket
  key         = "${local.s3_key_prefix}/${each.key}.zip"
  source      = each.value["file_path"]
  source_hash = filemd5(each.value["file_path"])
}

resource "aws_lambda_layer_version" "remote_s3" {
  depends_on = [aws_s3_object.file_upload]
  for_each   = var.lambda_layers_dependencies

  layer_name          = "${local.resource_prefix}${each.key}"
  description         = each.value["description"]
  s3_bucket           = var.s3_bucket
  s3_key              = aws_s3_object.file_upload[each.key].id
  source_code_hash    = aws_s3_object.file_upload[each.key].etag
  compatible_runtimes = var.runtimes
}
