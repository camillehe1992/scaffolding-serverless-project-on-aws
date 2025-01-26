variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs apply as tags to all resources in the module"
}

variable "role_name" {
  type        = string
  default     = "LambdaExecutionRole"
  description = "The name of IAM role"
}

variable "role_description" {
  type        = string
  default     = "The IAM role that grants the function permission to access AWS services and resources"
  description = "The description of IAM role"
}

variable "assume_role_policy_identifiers" {
  type        = list(string)
  default     = ["lambda.amazonaws.com"]
  description = "The AWS service identitifers that are allowed to assume the role"
}

variable "aws_managed_policy_arns" {
  type        = set(string)
  default     = []
  description = "A set of AWS managed policy ARN"
}

variable "customized_policy_json" {
  type        = string
  default     = ""
  description = "Policy document. This is a JSON formatted string."
}

variable "enable_iam_instance_profile" {
  type        = bool
  default     = false
  description = "Whether to create instance profile for the role or not"
}
