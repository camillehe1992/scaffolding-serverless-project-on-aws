variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "layer_name" {
  type        = string
  description = "The name of Lambda layer"
}

variable "description" {
  type        = string
  default     = "External dependencies that install via pip"
  description = "The description of Lambda layer"
}

variable "source_path" {
  type        = string
  default     = "requirements.txt"
  description = "Relative path to the function's requirement file within the current working directory"
}

variable "s3_bucket" {
  type        = string
  default     = ""
  description = "S3 bucket location containing the function's deployment package."
}

variable "s3_key_prefix" {
  type        = string
  description = "S3 object key prefix containing the function's deployment package."
}

variable "compatible_runtimes" {
  type        = list(string)
  description = "List of compatible runtimes of the Lambda layer, e.g. [python3.12]"
}

variable "compatible_architectures" {
  type    = string
  default = "arm64"
  validation {
    condition     = contains(["arm64", "x86_64"], var.architecture)
    error_message = "The architecture value must be arm64 or x86_64"
  }
  description = "The type of computer processor that Lambda uses to run the function"
}
