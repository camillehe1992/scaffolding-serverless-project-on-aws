module "dependencies_layer" {
  source = "../../modules/lambda_layer"

  resource_prefix = "${var.environment}-${var.nickname}-"

  layer_name   = "dependencies"
  source_path  = "../../../src/portal/requirements.txt"
  pip_install  = true
  from_local   = true
  architecture = var.architecture
  runtimes     = var.runtimes

  tags = var.tags
}
