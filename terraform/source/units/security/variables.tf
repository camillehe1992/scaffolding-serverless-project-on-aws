# General
variable "tags" {
  type        = map(string)
  description = "The tags to apply to the resources contained in this module"
  default     = {}
}

variable "env" {
  type        = string
  description = "The environment of application, such as dev, prod"
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "The env value must be dev, staging, or prod"
  }
}

variable "application_name" {
  type        = string
  description = "The name of application. Should be lowercase without special chars"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.application_name))
    error_message = "The application_name value must be lowercase without special chars"
  }
}

# IAM Roles and Policies
