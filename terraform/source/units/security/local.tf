locals {
  aws_region      = data.aws_region.current.region
  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_partition   = data.aws_partition.current.partition
  resource_prefix = "${var.env}-${var.application_name}"
}
