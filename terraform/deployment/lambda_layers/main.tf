module "lambda_layers" {
  source = "../../modules/lambda_layers"

  tags        = var.tags
  environment = var.environment
  nickname    = var.nickname

  lambda_layers_remote = {}
  lambda_layers_local  = {}
  lambda_layers_dependencies = {
    external-dependencies = {
      description = "Lambda function external dependencies"
      file_path   = "../../../build/requirements-external.zip"
    }
  }
  s3_bucket = var.s3_bucket
}
