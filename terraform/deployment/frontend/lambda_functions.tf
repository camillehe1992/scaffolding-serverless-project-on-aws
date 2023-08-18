module "lambda_functions" {
  source = "../../modules/lambda_functions"

  environment = var.environment
  nickname    = var.nickname
  tags        = var.tags

  # API Gateay triggered functions
  lambda_functions_specs = {
    frontend = {
      description      = "The general entrance of API Gateway"
      memory_size      = 128
      timeout          = 10
      runtime          = "python3.9"
      publish          = var.lambda_create_versions
      source_dir_path  = "../../../src/frontend/"
      source_file_path = null
      output_file_path = "../../../build/frontend.zip"
      handler          = "app.main.lambda_handler"
      layers_arns = [
        data.terraform_remote_state.lambda_layers.outputs.layers["external-dependencies"].arn,
      ]
      role_arn              = data.terraform_remote_state.common_infra.outputs.lambda_role.arn
      log_retention_days    = var.lambda_log_retention_days
      environment_variables = merge(local.lambda_default_env_variables, {})
      permissions = {
        api_gateway_rest_apis = {
          statement_id = "${local.lambda_gateway_permission_default_statement_id}-rest-apis"
          principal    = local.lambda_gateway_permission_default_principal
          source_arn   = "${module.api_gateway.arn}/*"
        }
      }
      event_sources      = {}
      subnet_ids         = []
      security_group_ids = []
    }
  }
}

