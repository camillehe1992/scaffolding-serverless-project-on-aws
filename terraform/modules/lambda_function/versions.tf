terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.1"
    }
  }
}
