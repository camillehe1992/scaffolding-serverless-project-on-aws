locals {
  s3_bucket = "terraform-state-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
}

module "lambda_execution_role" {
  source = "../../modules/iam"
  tags   = var.tags

  role_name = "${var.environment}-${var.nickname}-lambda-exection-role"
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  customized_policy_json = data.aws_iam_policy_document.customized.json
}

module "dependencies_layer" {
  source = "../../modules/lambda_layer_dependency"
  tags   = var.tags

  layer_name               = "${var.environment}-${var.nickname}-dependencies"
  source_path              = "../../../src/portal/requirements.txt"
  s3_bucket                = local.s3_bucket
  s3_key_prefix            = "${var.nickname}/${var.environment}/${data.aws_region.current.name}/"
  compatible_runtimes      = [var.runtime]
  compatible_architectures = [var.architecture]
}
