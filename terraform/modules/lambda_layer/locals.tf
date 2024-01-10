locals {
  resource_prefix = "${var.environment}-${var.nickname}-"
  s3_key_prefix   = "${var.nickname}/${var.environment}/${data.aws_region.current.name}"
  archive_path    = "${path.cwd}/build/${var.layer_name}"
}
