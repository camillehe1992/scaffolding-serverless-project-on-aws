output "parameters" {
  value = {
    for key, parameter in aws_ssm_parameter.parameters : key => {
      arn     = parameter.arn,
      version = parameter.version
    }
  }
}
