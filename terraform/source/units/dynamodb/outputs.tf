output "dynamodb_table_arns" {
  value = {
    for table_name, table in module.dynamodb_tables :
    table_name => table.table.arn
  }
}
