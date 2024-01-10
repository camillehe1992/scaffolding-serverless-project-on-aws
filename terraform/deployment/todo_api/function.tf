module "portal_function" {
  source = "../../modules/lambda_function"

  environment = var.environment
  nickname    = var.nickname
  tags        = var.tags

  function_name = "portal"
  description   = "The portal function that invoked by API Gateway"
  role_arn      = module.lambda_execution_role.iam_role.arn
  handler       = "app.main.lambda_handler"
  memory_size   = 128
  timeout       = 60
  runtime       = "python3.9"
  source_dir    = "../../../src/portal"
  output_path   = "build/portal.zip"

  layers = [
    module.dependencies_layer.layer.arn
  ]
  environment_variables = {}
  subnet_ids            = []
  security_group_ids    = []

  lambda_permissions = {
    allow-apigateway-invocation = {
      principal  = "apigateway.amazonaws.com"
      source_arn = "${module.api_gateway.rest_api.execution_arn}/*/*"
    }
  }
}
