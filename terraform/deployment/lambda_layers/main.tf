module "lambda_layers" {
  source = "../../modules/lambda_layers"

  environment = var.environment
  nickname    = var.nickname
  tags        = var.tags

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
