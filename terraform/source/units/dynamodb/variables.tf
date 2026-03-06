variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources"
  default     = {}
}

variable "env" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
  default     = "dev"
}

variable "application_name" {
  type        = string
  description = "The nickname of project. Should be lowercase without special chars"
}

variable "billing_mode" {
  type        = string
  description = "The capacity mode for billing"
  default     = "PROVISIONED"
}
