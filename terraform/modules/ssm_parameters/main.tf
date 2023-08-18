resource "aws_ssm_parameter" "parameters" {
  for_each = var.ssm_parameter_specs

  name        = upper("${local.resource_prefix}/${each.key}")
  description = each.value.parameter_description
  type        = local.parameter_type
  value       = each.value.parameter_value

  tags = var.tags
}
