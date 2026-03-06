# Security unit configuration - shared across all environments

# Unit-specific inputs for Security resources
inputs = {
  runtime      = "python3.12"
  architecture = "arm64"
  filename     = "${get_repo_root()}/.build/dependencies.zip"
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "security"
  }
}
