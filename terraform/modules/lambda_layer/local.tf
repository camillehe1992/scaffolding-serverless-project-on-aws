locals {
  default_s3_key_prefix = join("/", reverse(split(var.s3_key_prefix, "-")))
  s3_key_prefix         = var.s3_key_prefix == "" ? "${local.default_s3_key_prefix}/${data.aws_region.current.name}" : var.s3_key_prefix
  archive_path          = "${path.cwd}/build/${var.layer_name}"
  platform              = var.architecture == "arm64" ? "manylinux2014_aarch64" : "manylinux2014_x86_64"
}
