variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "env" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
}

variable "application_name" {
  type        = string
  description = "The name of project. Should be lowercase without special chars"
}

variable "role_arn" {
  type        = string
  description = "The ARN of Lambda execution role"
}

variable "handler" {
  type        = string
  description = "The handler of Lambda function"
  default     = "app.main.lambda_handler"
}

variable "source_dir" {
  type        = string
  description = "The directory of Lambda function source code"
}

variable "output_path" {
  type        = string
  description = "The zip file path of Lambda function"
}

variable "dependencies_layer_arn" {
  type        = string
  description = "The ARN of Lambda dependencies layer"
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

variable "app_version_filename" {
  type        = string
  description = "The path of application version file"
  default     = "VERSION.txt"
}
