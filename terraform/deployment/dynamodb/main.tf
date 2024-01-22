# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
module "todo_table" {
  source = "../../modules/dynamodb"

  resource_prefix = "${var.environment}-${var.nickname}-"
  tags            = var.tags

  name           = "todos"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
}
