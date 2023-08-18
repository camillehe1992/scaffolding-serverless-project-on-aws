locals {
  # API Gateway
  api_gateway_default_methods_spec = {
    use_authorizer   = false
    api_key_required = false
    # lambda function name without dev prefix
    integration_lambda_key = "frontend"
    request                = local.api_gateway_default_method_request
    integration_response   = local.api_gateway_default_integration_response
    responses = {
      200 = local.api_gateway_default_method_response
    }
  }
  api_gateway_default_method_response = {
    parameters = {
      "method.response.header.Access-Control-Allow-Origin" = false
      "method.response.header.Strict-Transport-Security"   = false
    }
    models = {
      "application/json" = "Empty"
    }
  }
  api_gateway_default_method_request = {
    parameters = null
    models     = null
  }
  api_gateway_default_id_path_parameters = {
    "method.request.path.id" = true
  }
  api_gateway_default_id_path_request_no_body = {
    parameters = local.api_gateway_default_id_path_parameters
    models     = null
  }
  api_gateway_default_id_path_request_json_body = {
    parameters = local.api_gateway_default_id_path_parameters
    models = {
      "application/json" = "Empty"
    }
  }
  api_gateway_default_integration_response = {
    parameters = {
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
      "method.response.header.Strict-Transport-Security"   = "'max-age=63072000; includeSubdomains'"
    }
    templates = {
      "application/json" = ""
    }
  }
  api_gateway_default_mock_method_specs = {
    use_authorizer         = false
    api_key_required       = false
    request                = local.api_gateway_default_method_request
    integration_lambda_key = null
    integration_response = {
      parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,Cache-Control'"
        "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,GET,PUT,DELETE,PATCH'"
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
        "method.response.header.Strict-Transport-Security"    = "'max-age=63072000; includeSubdomains'"
      }
      templates = {
        "application/json" = ""
      }
    }
    responses = {
      200 = {
        parameters = {
          "method.response.header.Access-Control-Allow-Headers" = false
          "method.response.header.Access-Control-Allow-Methods" = false
          "method.response.header.Access-Control-Allow-Origin"  = false
          "method.response.header.Strict-Transport-Security"    = false
        }
        models = {
          "application/json" = "Empty"
        }

      }
    }
  }
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
