# outputs.tf

output "role_id" {
  description = "The ID of the IAM role"
  value       = aws_iam_role.role.id
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role"
  value       = aws_iam_role.role.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.role.name
}

output "role_unique_id" {
  description = "The unique ID assigned by AWS to the IAM role"
  value       = aws_iam_role.role.unique_id
}

output "instance_profile_arn" {
  description = "The ARN of the IAM instance profile (if created)"
  value       = var.has_iam_instance_profile ? aws_iam_instance_profile.role_profile[0].arn : null
}
