module "dependencies_layer" {
  source = "../../modules/lambda_layer"

  environment = var.environment
  nickname    = var.nickname
  tags        = var.tags

  layer_name   = "dependencies"
  source_path  = "../../../src/portal/requirements.txt"
  pip_install  = true
  from_local   = true
  architecture = var.architecture
}
