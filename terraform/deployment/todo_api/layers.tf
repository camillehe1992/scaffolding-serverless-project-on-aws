module "dependencies_layer" {
  source = "../../modules/lambda_layer"

  resource_prefix = "${var.environment}-${var.nickname}-"
  tags            = var.tags

  layer_name   = "dependencies"
  source_path  = "../../../src/portal/requirements.txt"
  pip_install  = true
  from_local   = true
  architecture = var.architecture
}
