# General
variable "aws_region" {
  type        = string
  description = "AWS region which is used for the deployment"

}
variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS profile which is used for the deployment"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "environment" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
}

variable "nickname" {
  type        = string
  description = "The nickname of project. Should be lowercase without special chars"
}

# IAM Roles and Policies

# Lambda Layers
variable "runtimes" {
  type        = list(string)
  default     = ["python3.10"]
  description = "List of compatible runtimes of the Lambda layer, e.g. [python3.10]"
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
