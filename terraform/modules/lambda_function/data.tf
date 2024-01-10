data "archive_file" "this" {
  type        = "zip"
  source_file = var.source_file
  source_dir  = var.source_dir
  output_path = var.output_path
}
