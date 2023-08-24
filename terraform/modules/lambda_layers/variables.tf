variable "aws_region" {
  type        = string
  default     = "cn-north-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
}

variable "nickname" {
  type        = string
  description = "The nickname of project. Should be lowercase without special chars"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "lambda_layers_remote" {
  type = map(object({
    version = string
  }))
}

variable "lambda_layers_local" {
  type = map(object({
    description      = string
    source_dir_path  = string
    output_file_path = string
  }))
}

variable "lambda_layers_dependencies" {
  type = map(object({
    description = string
    file_path   = string
  }))
}

variable "runtimes" {
  type        = list(string)
  description = "List of compatible runtimes of the Lambda layer, e.g. [python3.9]"
  default     = ["python3.9"]
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket location containing the function's deployment package. Conflicts with filename. This bucket must reside in the same AWS region where you are creating the Lambda function."
}
