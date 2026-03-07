locals {
  resource_prefix = "${var.env}-${var.application_name}"
  dynamodb_table_specs = {
    users = {
      hash_key = "id"
    },
    todos = {
      hash_key = "id"
      global_secondary_indexes = {
        # The key of each index must be the same value as value.hash_key
        user_id = {
          name            = "user_id-index"
          hash_key        = "user_id"
          key_type        = "HASH"
          projection_type = "ALL"
        }
      }
    },
  }
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
module "dynamodb_tables" {
  for_each = local.dynamodb_table_specs
  source   = "../../modules/dynamodb"

  table_name                  = "${local.resource_prefix}-${each.key}"
  hash_key                    = try(each.value.hash_key, "id")
  range_key                   = try(each.value.range_key, null)
  deletion_protection_enabled = try(each.value.deletion_protection_enabled, false)
  global_secondary_indexes    = try(each.value.global_secondary_indexes, {})
  billing_mode                = try(each.value.billing_mode, var.billing_mode)
  read_capacity               = try(each.value.read_capacity, local.read_capacity)
  write_capacity              = try(each.value.write_capacity, local.write_capacity)
  stream_enabled              = try(each.value.stream_enabled, false)
  # Only valid when stream_enabled is true
  stream_view_type = try(each.value.stream_view_type, null)

  tags = var.tags
}
