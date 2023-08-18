locals {
  resource_prefix = "${var.environment}-${var.nickname}-"
  lambda_function_file_code = {
    for lambda_function_key, lambda_function_specs in var.lambda_functions_specs : lambda_function_key => {
      source_file = lambda_function_specs["source_file_path"]
      source_dir  = lambda_function_specs["source_dir_path"]
      output_path = lambda_function_specs["output_file_path"]
    }
  }
  lambda_functions_permissions_array = flatten([
    for lambda_function_key, lambda_function_specs in var.lambda_functions_specs : [
      for key, permission in lambda_function_specs["permissions"] : {
        key = key, lambda_function_key = lambda_function_key, permission = permission
      }
    ]
  ])
  lambda_functions_permissions = {
    for lambda_permission in local.lambda_functions_permissions_array : "${lambda_permission["lambda_function_key"]}_${lambda_permission["key"]}" => {
      lambda_function_key = lambda_permission["lambda_function_key"]
      permission          = lambda_permission["permission"]
    }
  }
  lambda_functions_event_sources_array = flatten([
    for lambda_function_key, lambda_function_specs in var.lambda_functions_specs : [
      for key, event_source in lambda_function_specs["event_sources"] : {
        key = key, lambda_function_key = lambda_function_key, event_source = event_source
      }
    ]
  ])
  lambda_functions_event_sources = {
    for lambda_event_source in local.lambda_functions_event_sources_array : "${lambda_event_source["lambda_function_key"]}_${lambda_event_source["key"]}" => {
      lambda_function_key = lambda_event_source["lambda_function_key"]
      event_source        = lambda_event_source["event_source"]
    }
  }
}
