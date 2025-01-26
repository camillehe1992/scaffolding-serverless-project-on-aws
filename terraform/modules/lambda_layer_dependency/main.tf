resource "null_resource" "pip_install" {
  triggers = {
    shell_hash = sha256(file(var.source_path))
  }

  provisioner "local-exec" {
    command = <<EOF
      rm -rf ${local.archive_path}
      python3 -m pip install -r ${var.source_path} \
        --platform ${local.platform} \
        -t ${local.archive_path}/python --only-binary=:all:
    EOF
  }
}

data "archive_file" "this" {
  depends_on = [null_resource.pip_install]

  type        = "zip"
  source_dir  = local.archive_path
  output_path = "${local.archive_path}.zip"
}

resource "aws_s3_object" "zip_file" {
  depends_on = [data.archive_file.this]

  bucket                 = var.s3_bucket
  key                    = "${var.s3_key_prefix}${var.layer_name}.zip"
  source                 = data.archive_file.this.output_path
  server_side_encryption = "aws:kms"

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version
resource "aws_lambda_layer_version" "this" {
  depends_on = [aws_s3_object.zip_file]

  layer_name               = var.layer_name
  description              = var.description
  s3_bucket                = aws_s3_object.zip_file.bucket
  s3_key                   = aws_s3_object.zip_file.key
  compatible_architectures = var.compatible_architectures
  compatible_runtimes      = var.compatible_runtimes
}
