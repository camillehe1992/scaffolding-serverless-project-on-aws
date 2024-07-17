# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
module "todos_table" {
  source = "../../modules/dynamodb"

  resource_prefix = "${var.environment}-${var.nickname}-"
  tags            = var.tags

  name           = "todos"
  billing_mode   = var.billing_mode
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"
  range_key      = "title"
}

module "users_table" {
  source = "../../modules/dynamodb"

  resource_prefix = "${var.environment}-${var.nickname}-"
  tags            = var.tags

  name           = "users"
  billing_mode   = var.billing_mode
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"
  range_key      = "email"
}
