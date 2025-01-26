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

# API Gateway
variable "retention_in_days" {
  type        = number
  default     = 30
  description = <<EOF
    Specifies the number of days you want to retain log events in the specific api gateway log group.
    Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653
  EOF
}

# Lambda Functions
variable "runtime" {
  type        = string
  description = "The runtime of Lambda function"
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

variable "log_level" {
  type        = string
  description = "The log level of Lambda function. Default INFO"
  default     = "INFO"
}

variable "app_version" {
  type        = string
  description = "The application version, for example 0.0.1"
  default     = "0.0.1"
}
