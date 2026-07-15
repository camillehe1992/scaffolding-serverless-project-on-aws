# variables.tf

variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "role_description" {
  description = "The description of the IAM role"
  type        = string
  default     = "IAM role created by Terraform"
}

variable "assume_role_policy" {
  description = "The assume role policy document in JSON format that defines which entities can assume the role"
  type        = string
  nullable    = true
  default     = null
}

variable "principals" {
  description = "A map of principals that can assume the role. The key is the principal type, value is a list of principal identifiers"
  type = map(object({
    type        = string
    identifiers = list(string)
  }))
  default = {
    "Service" = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

variable "aws_managed_policy_arns" {
  description = "A set of AWS managed policy ARNs to attach to the role"
  type        = set(string)
  default     = []
}

variable "user_managed_policies" {
  description = "A map of custom IAM policies to create and attach to the role. The key is the policy name suffix, value is the policy document in JSON format"
  type        = map(string)
  default     = {}
}

variable "has_iam_instance_profile" {
  description = "Whether to create an IAM instance profile for the role (useful for EC2 instances)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
