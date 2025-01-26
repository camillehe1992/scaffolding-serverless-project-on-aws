locals {
  archive_path = "${path.cwd}/build/${var.layer_name}"
  platform     = var.compatible_architectures[0] == "arm64" ? "manylinux2014_aarch64" : "manylinux2014_x86_64"
}
