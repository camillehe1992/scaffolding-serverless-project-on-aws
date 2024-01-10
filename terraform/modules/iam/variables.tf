variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs apply as tags to all resources in the module"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "The prefix of the IAM role name"
}

variable "role_name" {
  type        = string
  default     = "LambdaExecutionRole"
  description = "The name of IAM role"
}

variable "role_description" {
  type        = string
  default     = ""
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

variable "customized_policies" {
  type        = map(string)
  default     = {}
  description = "A map of JSON format of IAM policy"
}

variable "has_iam_instance_profile" {
  type        = bool
  default     = false
  description = "If to create instance profile for the role"
}
