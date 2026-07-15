
locals {
  range_key = var.range_key != null ? [var.range_key] : []
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "this" {
  name                        = var.table_name
  billing_mode                = var.billing_mode
  read_capacity               = var.read_capacity
  write_capacity              = var.write_capacity
  hash_key                    = var.hash_key # Partition key
  range_key                   = var.range_key
  deletion_protection_enabled = var.deletion_protection_enabled

  # Attribute definitions (only for keys and indexes)
  attribute {
    name = var.hash_key
    type = "S"
  }

  dynamic "attribute" {
    for_each = concat(local.range_key, keys(var.global_secondary_indexes))
    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name = global_secondary_index.value.name
      key_schema {
        attribute_name = global_secondary_index.value.hash_key
        key_type       = global_secondary_index.value.key_type
      }
      read_capacity   = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
      write_capacity  = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
      projection_type = global_secondary_index.value.projection_type
    }
  }

  # Optional: Enable DynamoDB Streams for change data capture
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? var.stream_view_type : null # Only if streams are enabled

  tags = var.tags
}
