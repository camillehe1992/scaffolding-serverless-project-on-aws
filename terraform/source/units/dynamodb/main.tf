locals {
  resource_prefix = "${var.env}-${var.application_name}"
  dynamodb_table_specs = {
    todos = {
      table_name   = "${local.resource_prefix}-todos"
      billing_mode = var.billing_mode
      hash_key     = "id"
      range_key    = "title"
    },
    users = {
      table_name   = "${local.resource_prefix}-users"
      billing_mode = var.billing_mode
      hash_key     = "id"
      range_key    = "email"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
module "dynamodb_tables" {
  for_each = local.dynamodb_table_specs
  source   = "../../modules/dynamodb"

  table_name = each.value.table_name
  hash_key   = each.value.hash_key
  range_key  = each.value.range_key

  billing_mode = var.billing_mode
  tags         = var.tags
}
