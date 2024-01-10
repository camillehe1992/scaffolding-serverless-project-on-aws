module "dependencies_layer" {
  source = "../../modules/lambda_layer"

  environment = var.environment
  nickname    = var.nickname
  tags        = var.tags

  layer_name  = "dependencies"
  source_path = "../../../src/lambda_layers/requirements.txt"
  pip_install = true
  from_local  = true
}
