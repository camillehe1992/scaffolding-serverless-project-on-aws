terraform {
  backend "s3" {}
  required_version = ">~ 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.1"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "default" ? var.aws_profile : null
}