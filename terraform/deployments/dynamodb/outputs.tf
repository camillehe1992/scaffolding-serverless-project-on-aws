output "todos_table_arn" {
  value = module.todos_table.table.arn
}

output "users_table_arn" {
  value = module.users_table.table.arn
}
