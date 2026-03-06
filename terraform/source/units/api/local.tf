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
  app_version                            = data.local_file.app_version.content
  current_timestamp                      = timestamp()
  deployed_at                            = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", local.current_timestamp)
  default_environment_variables = {
    APP_VERSION             = local.app_version
    DEPLOYED_AT             = local.deployed_at
    ENVIRONMENT             = var.env
    LOG_LEVEL               = var.log_level
    NICKNAME                = var.application_name
    POWERTOOLS_LOG_LEVEL    = var.log_level
    POWERTOOLS_SERVICE_NAME = var.application_name
  }
}
