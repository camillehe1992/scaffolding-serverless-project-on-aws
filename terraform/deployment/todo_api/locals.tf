locals {
  lambda_default_env_variables = {
    ENV                     = var.environment
    NICKNAME                = var.nickname
    POWERTOOLS_SERVICE_NAME = var.nickname
    LOG_LEVEL               = var.log_level
  }
}
