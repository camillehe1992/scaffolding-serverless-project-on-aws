data "aws_region" "current" {}

resource "null_resource" "pip_install" {
  count = var.pip_install ? 1 : 0

  triggers = {
    shell_hash = sha256(file(var.source_path))
    timestamp  = timestamp()
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

data "archive_file" "dependencies" {
  count      = var.pip_install ? 1 : 0
  depends_on = [null_resource.pip_install]

  type        = "zip"
  source_dir  = local.archive_path
  output_path = "${local.archive_path}.zip"
}

data "archive_file" "custom" {
  count = var.is_custom ? 1 : 0

  type        = "zip"
  source_dir  = var.source_path
  output_path = "${local.archive_path}.zip"
}

resource "aws_lambda_layer_version" "from_local" {
  count      = var.from_local ? 1 : 0
  depends_on = [data.archive_file.dependencies]

  layer_name               = "${var.resource_prefix}${var.layer_name}"
  description              = var.description
  filename                 = "${local.archive_path}.zip"
  source_code_hash         = var.pip_install ? data.archive_file.dependencies[count.index].output_base64sha256 : data.archive_file.custom[count.index].output_base64sha256
  compatible_runtimes      = var.runtimes
  compatible_architectures = toset([var.architecture])
}

# For deployment package (.zip file archive) with size more than 50 MB (zipped, for direct upload)
# This quota applies to all the files you upload, including layers and custom runtimes.
# 3 MB (console editor). upload zip file to s3 then create lambda layer
data "archive_file" "s3_object" {
  count      = var.from_s3 ? 1 : 0
  depends_on = [null_resource.pip_install]

  type        = "zip"
  source_dir  = local.archive_path
  output_path = "${local.archive_path}.zip"
}

resource "aws_s3_object" "file_upload" {
  count      = var.from_s3 ? 1 : 0
  depends_on = [data.archive_file.s3_object]

  bucket      = var.s3_bucket
  key         = "${var.s3_key_prefix}/${var.layer_name}.zip"
  source      = data.archive_file.s3_object[count.index].output_path
  source_hash = data.archive_file.s3_object[count.index].output_base64sha256

  tags = var.tags
}

resource "aws_lambda_layer_version" "from_s3" {
  count      = var.from_s3 ? 1 : 0
  depends_on = [aws_s3_object.file_upload]

  layer_name          = "${var.resource_prefix}${var.layer_name}"
  description         = var.description
  s3_bucket           = var.s3_bucket
  s3_key              = "${local.s3_key_prefix}/${var.layer_name}.zip"
  source_code_hash    = aws_s3_object.file_upload[count.index].etag
  compatible_runtimes = var.runtimes
}
