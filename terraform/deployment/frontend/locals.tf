locals {
  # Lambda Functions
  lambda_gateway_permission_default_statement_id     = "AllowAPIGatewayInvoke"
  lambda_gateway_permission_default_principal        = "apigateway.amazonaws.com"
  lambda_cloud_watch_permission_default_statement_id = "AllowCloudWatchEventsInvoke"
  lambda_cloud_watch_permission_default_principal    = "events.amazonaws.com"
  lambda_default_env_variables = {
    ENV                     = var.environment
    NICKNAME                = var.nickname
    POWERTOOLS_SERVICE_NAME = var.nickname
    LOG_LEVEL               = var.log_level
  }
}
