# General
variable "tags" {
  type        = map(string)
  description = "The tags to apply to the resources contained in this module"
  default     = {}
}

variable "env" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
  default     = "dev"
  validation {
    condition     = contains(["dev", "int", "prod"], var.env)
    error_message = "The env value must be dev, int, or prod"
  }
}

variable "application_name" {
  type        = string
  description = "The name of project. Should be lowercase without special chars"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.application_name))
    error_message = "The application_name value must be lowercase without special chars"
  }
}

# API Gateway
variable "log_retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain API Gateway and Lambda function logs"
  default     = 30
}

# Lambda Function
variable "role_arn" {
  type        = string
  description = "The ARN of Lambda execution role"
}

variable "handler" {
  type        = string
  description = "The handler of Lambda function"
  default     = "app.main.lambda_handler"
}

variable "lambda_runtime" {
  type        = string
  description = "The runtime of Lambda function"
  default     = "python3.14"
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

variable "source_dir" {
  type        = string
  description = "The directory of Lambda function source code"
}

variable "output_path" {
  type        = string
  description = "The zip file path of Lambda function"
}

# Lambda Function Environment Variables
variable "lambda_environment_variables" {
  type        = map(string)
  description = "The environment variables of Lambda function"
  default     = {}
}

# Lambda Layer
variable "dependencies_layer_build_script_path" {
  type        = string
  description = "Path to the script that builds the Lambda dependencies layer zip"
}

variable "dependencies_layer_file_path" {
  type        = string
  description = "Path to the file that be read as Lambda dependencies layer"
}
