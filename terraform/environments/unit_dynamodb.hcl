# DynamoDB unit configuration - shared across all environments

# Unit-specific inputs for DynamoDB resources
inputs = {}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "dynamodb"
  }
}
