data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "common_infra" {
  backend = "s3"
  config = {
    region = data.aws_region.current.name
    bucket = "terraform-state-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
    key    = "${var.nickname}/${var.environment}/${data.aws_region.current.name}/common_infra.tfstate"
  }
}
