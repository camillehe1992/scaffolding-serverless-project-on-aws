# Development environment configuration
locals {
  # Environment-specific settings
  env = "dev"

  # Development-specific configuration
  config = {
    # Compute environment settings
  }

  # Environment-specific tags
  environment_tags = {
    Environment = local.env
  }
}
