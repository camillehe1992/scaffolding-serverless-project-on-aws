data "terraform_remote_state" "common_infra" {
  backend = "s3"

  config = {
    region  = var.aws_region
    bucket  = var.s3_bucket
    key     = "${var.nickname}/${var.environment}/${var.aws_region}/common_infra.tfstate"
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "lambda_layers" {
  backend = "s3"

  config = {
    region  = var.aws_region
    bucket  = var.s3_bucket
    key     = "${var.nickname}/${var.environment}/${var.aws_region}/lambda_layers.tfstate"
    profile = var.aws_profile
  }
}
