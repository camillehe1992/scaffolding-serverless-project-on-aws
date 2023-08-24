output "layers" {
  value = {
    for key, lambda_layer in merge(data.aws_lambda_layer_version.remote, aws_lambda_layer_version.local, aws_lambda_layer_version.remote_s3) : key => {
      id         = lambda_layer.id,
      layer_name = lambda_layer.layer_name,
      version    = lambda_layer.version
      arn        = lambda_layer.arn
      layer_arn  = lambda_layer.layer_arn
    }
  }
}
