# https://registry.terraform.io/providers/hashicorp/aws/lastest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.retention_in_days

  tags = var.tags
}

data "archive_file" "this" {
  type        = "zip"
  source_file = var.source_file
  source_dir  = var.source_dir
  output_path = var.output_path
}

# https://registry.terraform.io/providers/hashicorp/aws/lastest/docs/resources/lambda_function
resource "aws_lambda_function" "this" {
  depends_on = [data.archive_file.this]

  function_name    = var.function_name
  description      = var.description
  role             = var.role_arn
  handler          = var.handler
  memory_size      = var.memory_size
  runtime          = var.runtime
  timeout          = var.timeout
  architectures    = [var.architecture]
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  layers           = var.layers

  environment {
    variables = var.environment_variables
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/lastest/docs/resources/lambda_permission
resource "aws_lambda_permission" "this" {
  for_each = var.lambda_permissions

  statement_id  = each.key
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}
