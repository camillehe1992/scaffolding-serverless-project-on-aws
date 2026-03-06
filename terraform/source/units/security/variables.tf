# General
variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "env" {
  type        = string
  description = "The environment of application, such as dev, prod"
  default     = "dev"

}

variable "application_name" {
  type        = string
  description = "The name of application. Should be lowercase without special chars"
  default     = ""
}

# IAM Roles and Policies

# Lambda Layers
variable "filename" {
  type        = string
  description = "Path to the file that be read"
}
variable "runtime" {
  type        = string
  description = "The runtime of Lambda layer"
  default     = "python3.12"
}

variable "architecture" {
  type    = string
  default = "arm64"
  validation {
    condition     = contains(["arm64", "x86_64"], var.architecture)
    error_message = "The architecture value must be arm64 or x86_64"
  }
  description = "The type of computer processor that Lambda uses to run the function"
}
