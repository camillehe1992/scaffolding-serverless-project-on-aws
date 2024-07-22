data "aws_region" "current" {}

data "terraform_remote_state" "common_infra" {
  backend = "s3"
  config = {
    region  = data.aws_region.current.name
    bucket  = "terraform-state-${data.aws_region.current.name}-bucket"
    key     = "${var.nickname}/${var.environment}/${data.aws_region.current.name}/common_infra.tfstate"
    profile = var.aws_profile != "default" ? var.aws_profile : null
  }
}
