locals {
  aws_region               = data.aws_region.current.region
  aws_account_id           = data.aws_caller_identity.current.account_id
  aws_partition            = data.aws_partition.current.partition
  resource_prefix          = "${var.env}-${var.application_name}"
  python_version           = replace(var.lambda_runtime, ".", "")
  powertools_layer_version = 27

  aws_lambda_powertools_lambda_layer_arns = {
    arm = "arn:${local.aws_partition}:lambda:${local.aws_region}:017000801446:layer:AWSLambdaPowertoolsPythonV3-${local.python_version}-arm64:${local.powertools_layer_version}",
    x86 = "arn:${local.aws_partition}:lambda:${local.aws_region}:017000801446:layer:AWSLambdaPowertoolsPythonV3-${local.python_version}-x86_64:${local.powertools_layer_version}"
  }
  aws_lambda_powertools_lambda_layer_arn = var.architecture == "arm64" ? local.aws_lambda_powertools_lambda_layer_arns.arm : local.aws_lambda_powertools_lambda_layer_arns.x86
}
