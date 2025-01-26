data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.cwd}/build/${var.layer_name}"
  output_path = "${path.cwd}/build/${var.layer_name}.zip"
}

resource "aws_s3_object" "zip_file" {
  depends_on = [data.archive_file.this]

  bucket      = var.s3_bucket
  key         = "${var.s3_key_prefix}/${var.layer_name}.zip"
  source      = data.archive_file.this.output_path
  source_hash = data.archive_file.this.output_base64sha256

  tags = var.tags
}

resource "aws_lambda_layer_version" "this" {
  depends_on = [aws_s3_object.zip_file]

  layer_name               = var.layer_name
  description              = var.description
  s3_bucket                = aws_s3_object.zip_file.bucket
  s3_key                   = aws_s3_object.zip_file.key
  compatible_architectures = var.compatible_architectures
  compatible_runtimes      = var.compatible_runtimes
}
