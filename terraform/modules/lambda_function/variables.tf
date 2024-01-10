variable "environment" {
  type        = string
  description = "The environment of application"
}

variable "nickname" {
  type        = string
  description = "The nickname of application. Must be lowercase without special chars"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "function_name" {
  type        = string
  description = "The Lambda function name"
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of Lambda function"
}

variable "role_arn" {
  type        = string
  description = "The ARN of Lambda function excution role"
}

variable "handler" {
  type        = string
  description = "The handler of Lambda function"
}

variable "memory_size" {
  type        = number
  default     = 128
  description = "The memory size (MiB) of Lambda function"
}

variable "timeout" {
  type        = number
  default     = 60
  description = "The timeout (seconds) of Lambda function"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
  description = "The runtime of Lambda function"
}

variable "source_file" {
  type        = string
  default     = null
  description = "The file name of Lambda function source code"
}

variable "source_dir" {
  type        = string
  default     = null
  description = "The source dir of Lambda function source code. Conflict with source_file"
}

variable "output_path" {
  type        = string
  description = "The zip file name of Lambda function source code"
}

variable "layers" {
  type        = list(string)
  default     = []
  description = "A list of Lambda function associated layers ARN"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "A set of environment variables of Lambda function"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of Subnet Ids"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "A list of Security group Ids"
}

variable "retention_in_days" {
  type        = number
  default     = 14
  description = "The retention (days) of Lambda function Cloudwatch logs group"
}

variable "lambda_permissions" {
  type = map(object({
    principal  = string
    source_arn = string
  }))
  default     = {}
  description = "A map of lambda permissions"
}
