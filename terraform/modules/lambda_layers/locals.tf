locals {
  resource_prefix = "${var.environment}-${var.nickname}-"
  s3_key_prefix   = "${var.nickname}/${var.environment}/${var.aws_region}"
}
