terraform {
  backend "s3" {
    region = "cn-north-1"
  }

  required_version = "= 1.3.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
