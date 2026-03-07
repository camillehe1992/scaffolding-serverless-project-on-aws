locals {
  aws_region      = data.aws_region.current.region
  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_partition   = data.aws_partition.current.partition
  resource_prefix = "${var.env}-${var.application_name}"

  aws_lambda_powertools_lambda_layer_arns = {
    arm = "arn:aws:lambda:${local.aws_region}:017000801446:layer:AWSLambdaPowertoolsPythonV3-python312-arm64:5",
    x86 = "arn:aws:lambda:${local.aws_region}:017000801446:layer:AWSLambdaPowertoolsPythonV3-python312-x86_64:5"
  }
  aws_lambda_powertools_lambda_layer_arn = var.architecture == "arm64" ? local.aws_lambda_powertools_lambda_layer_arns.arm : local.aws_lambda_powertools_lambda_layer_arns.x86
}
