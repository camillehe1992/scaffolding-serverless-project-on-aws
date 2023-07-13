output "functions" {
  value = {
    for key, lambda_function in aws_lambda_function.functions : key => {
      id            = lambda_function.id,
      function_name = lambda_function.function_name,
      version       = lambda_function.version
      arn           = lambda_function.arn
      invoke_arn    = lambda_function.invoke_arn
    }
  }
}

output "lambda_permissions" {
  value = {
    for key, lambda_permission in aws_lambda_permission.permissions : key => {
      id            = lambda_permission.id,
      arn           = lambda_permission.source_arn,
      function_name = lambda_permission.function_name,
      account       = lambda_permission.source_account,
      statement_id  = lambda_permission.statement_id
    }
  }
}

output "lambda_log_group" {
  value = {
    for key, lambda_log in aws_cloudwatch_log_group.lambda_logs : key => {
      id   = lambda_log.id,
      name = lambda_log.name
    }
  }
}

output "lambda_event_source_mapping" {
  value = {
    for key, mapping in aws_lambda_event_source_mapping.event_source : key => {
      id   = mapping.uuid,
      name = mapping.function_name,
      arn  = mapping.event_source_arn
    }
  }
}
