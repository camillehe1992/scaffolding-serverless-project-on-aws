# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
module "todos_table" {
  source = "../../modules/dynamodb"
  tags   = var.tags

  table_name   = "${var.environment}-${var.nickname}-todos"
  billing_mode = var.billing_mode
  hash_key     = "id"
  range_key    = "title"
}

module "users_table" {
  source = "../../modules/dynamodb"
  tags   = var.tags

  table_name   = "${var.environment}-${var.nickname}-users"
  billing_mode = var.billing_mode
  hash_key     = "id"
  range_key    = "email"
}
