# Root Terragrunt configuration

locals {
  # Get environment from directory structure
  environment = basename(dirname(get_terragrunt_dir()))

  repository_name = "scaffolding-serverless-project-on-aws"

  # Region configuration
  regions = {
    dev     = "ap-southeast-1"
    staging = "ap-southeast-1"
    prod    = "ap-southeast-1"
  }

  # Get current account from the active AWS credentials.
  current_account_id = get_aws_account_id()
  current_region     = local.regions[local.environment]
}

terraform {
  source = "${get_terragrunt_dir()}/../../../source//units/${basename(get_original_terragrunt_dir())}"
  extra_arguments "plan" {
    commands  = ["plan"]
    arguments = ["-parallelism", "10", "-out=${get_terragrunt_dir()}/terraform.plan"]
  }
  # extra_arguments "apply" {
  #   commands = ["apply"]
  #   arguments = ["-parallelism", "10", "${get_terragrunt_dir()}/terraform.plan"]
  # }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_version = ">= 1.14.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.7.0"
    }
  }
}

provider "aws" {
  region = "${local.current_region}"

  default_tags {
    tags = {
      Environment = "${local.environment}"
      ManagedBy   = "terragrunt"
      Terraform   = "true"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
EOF
}

# Remote state configuration
remote_state {
  backend = "s3"
  config = {
    bucket       = "terraform-state-${local.current_account_id}-${local.current_region}"
    key          = "${local.repository_name}/${path_relative_to_include()}/terraform.tfstate"
    region       = local.current_region
    encrypt      = true
    use_lockfile = true
  }
}
