# API unit configuration - shared across all environments

# Unit-specific inputs for API resources
inputs = {
  runtime              = "python3.12"
  architecture         = "arm64"
  source_dir           = "${get_repo_root()}/src/portal"
  output_path          = "${get_repo_root()}/.build/portal.zip"
  app_version_filename = "${get_repo_root()}/VERSION.txt"
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "api"
  }
}
