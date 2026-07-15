# Development environment configuration
locals {
  env = "dev"
  # Environment-specific tags
  environment_tags = {
    Environment = local.env
  }
}
