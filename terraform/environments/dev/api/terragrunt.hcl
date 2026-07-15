# Local configuration that combines all includes
locals {
  application_name = include.common.locals.application_name
  env              = include.env.locals.env
  tags = merge(
    include.common.locals.common_tags,
    include.env.locals.environment_tags,
    include.unit_api.locals.unit_tags
  )
}

# Unit-specific inputs
inputs = merge(
  include.unit_api.inputs,
  {
    application_name = local.application_name
    env              = local.env
    tags             = local.tags
    # Lambda Function
    log_retention_in_days = 30
    lambda_environment_variables = {
      APP_VERSION             = include.unit_api.locals.app_version
      APPLICATION_NAME        = local.application_name
      ENVIRONMENT             = local.env
      POWERTOOLS_LOG_LEVEL    = "DEBUG"
      POWERTOOLS_SERVICE_NAME = local.application_name
    }
    # Dependency
    role_arn = dependency.security.outputs.lambda_execution_role_arn
  }
)

# Include root/ common/ and env/ modules
include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

include "unit_api" {
  path   = find_in_parent_folders("unit_api.hcl")
  expose = true
}

dependency "security" {
  config_path = "../security"
  mock_outputs = {
    lambda_execution_role_arn = "arn:aws:iam::123456789012:role/lambda-execution-role"
  }
}
