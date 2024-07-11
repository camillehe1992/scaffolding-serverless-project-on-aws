locals {
  aws_lambda_powertools_lambda_layer_arns = {
    arm = "arn:aws:lambda:${data.aws_region.current.name}:017000801446:layer:AWSLambdaPowertoolsPythonV2-Arm64:75",
    x86 = "arn:aws:lambda:${data.aws_region.current.name}:017000801446:layer:AWSLambdaPowertoolsPythonV2:75"
  }
  aws_lambda_powertools_lambda_layer_arn = var.architecture == "arm64" ? local.aws_lambda_powertools_lambda_layer_arns.arm : local.aws_lambda_powertools_lambda_layer_arns.x86
}
