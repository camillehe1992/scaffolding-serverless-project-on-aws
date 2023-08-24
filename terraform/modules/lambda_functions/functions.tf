data "archive_file" "file_code" {
  for_each = local.lambda_function_file_code

  type        = "zip"
  source_file = each.value["source_file"]
  source_dir  = each.value["source_dir"]
  output_path = each.value["output_path"]
}

resource "aws_lambda_function" "functions" {
  for_each = var.lambda_functions_specs

  function_name    = "${local.resource_prefix}${each.key}"
  description      = each.value["description"]
  memory_size      = each.value["memory_size"]
  timeout          = each.value["timeout"]
  runtime          = each.value["runtime"]
  publish          = each.value["publish"]
  role             = each.value["role_arn"]
  filename         = each.value["output_file_path"]
  source_code_hash = data.archive_file.file_code[each.key].output_base64sha256
  handler          = each.value["handler"]
  layers           = each.value["layers_arns"]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = each.value["environment_variables"]
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs
  ]

  vpc_config {
    subnet_ids         = each.value["subnet_ids"]
    security_group_ids = each.value["security_group_ids"]
  }

  tags = var.tags
}

resource "aws_lambda_permission" "permissions" {
  for_each = local.lambda_functions_permissions

  function_name = aws_lambda_function.functions[each.value["lambda_function_key"]].function_name
  action        = "lambda:InvokeFunction"
  statement_id  = each.value["permission"]["statement_id"]
  principal     = each.value["permission"]["principal"]
  source_arn    = each.value["permission"]["source_arn"]
}

resource "aws_lambda_event_source_mapping" "event_source" {
  for_each = local.lambda_functions_event_sources

  function_name                 = aws_lambda_function.functions[each.value["lambda_function_key"]].function_name
  enabled                       = each.value["event_source"]["enabled"]
  batch_size                    = each.value["event_source"]["batch_size"]
  starting_position             = each.value["event_source"]["starting_position"]
  event_source_arn              = each.value["event_source"]["source_arn"]
  maximum_record_age_in_seconds = length(regexall(".*dynamo.*", each.value["event_source"]["source_arn"])) > 0 ? var.max_age_for_dynamo_records_in_sec : null
  maximum_retry_attempts        = length(regexall(".*dynamo.*", each.value["event_source"]["source_arn"])) > 0 ? var.max_retry_for_dynamo_records : null
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  for_each = var.lambda_functions_specs

  name              = "/aws/lambda/${local.resource_prefix}${each.key}"
  retention_in_days = each.value["log_retention_days"]

  tags = var.tags
}
