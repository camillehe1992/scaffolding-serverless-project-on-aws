# Read content from an existing local file
data "local_file" "app_version" {
  filename = var.app_version_filename
}
