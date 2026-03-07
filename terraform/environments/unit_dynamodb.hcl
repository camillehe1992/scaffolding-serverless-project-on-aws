# DynamoDB unit configuration - shared across all environments

# Unit-specific inputs for DynamoDB resources
inputs = {
  billing_mode = "PAY_PER_REQUEST"
  # Provisioned throughput capacity if billing_mode is PROVISIONED
  read_capacity  = null
  write_capacity = null
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "dynamodb"
  }
}
