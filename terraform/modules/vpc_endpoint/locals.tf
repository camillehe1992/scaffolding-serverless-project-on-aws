locals {
  partition = var.aws_partition == "aws-cn" ? "cn." : ""
}
