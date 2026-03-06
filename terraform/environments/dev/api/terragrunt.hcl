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
    retention_in_days      = 30
    log_level              = "DEBUG"
    role_arn               = dependency.security.outputs.lambda_execution_role_arn
    dependencies_layer_arn = dependency.security.outputs.dependencies_layer_arn
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
    dependencies_layer_arn    = "arn:aws:lambda:us-east-1:123456789012:layer:dependencies-layer:1"
  }
}
