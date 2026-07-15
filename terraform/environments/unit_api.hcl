# API unit configuration - shared across all environments

# Unit-specific inputs for API resources
inputs = {
  handler                      = "app.main.lambda_handler"
  lambda_runtime               = "python3.14"
  architecture                 = "arm64"
  source_dir                   = "${get_repo_root()}/src/portal"
  output_path                  = "${get_repo_root()}/.build/portal.zip"
  dependencies_layer_file_path = "${get_repo_root()}/.build/dependencies.zip"
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "api"
  }
  app_version = file("${get_repo_root()}/VERSION.txt")
}
