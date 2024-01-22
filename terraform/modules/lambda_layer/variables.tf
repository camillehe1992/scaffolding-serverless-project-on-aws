variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "resource_prefix" {
  type        = string
  description = "The prefix of resources name"
}

variable "layer_name" {
  type        = string
  description = "The name of Lambda layer"
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of Lambda layer"
}

# variable "npm_install" {
#   type        = bool
#   default     = false
#   description = "Whether to npm install dependencies. Default false"
# }

variable "pip_install" {
  type        = bool
  default     = false
  description = "Whether to pip install dependencies. Default false"
}

variable "from_local" {
  type        = bool
  default     = false
  description = "Whether the package archived file is uploaded from local. Default false"
}

variable "source_path" {
  type        = string
  default     = "requirements.txt"
  description = "Relative path to the function's requirement file within the current working directory"
}

variable "is_custom" {
  type        = bool
  default     = false
  description = "Whether the package source code is saved in current file system. Default false"
}

variable "from_s3" {
  type        = bool
  default     = false
  description = "Whether the package source code is uploaded to s3, then create layer. Default false"
}

variable "s3_bucket" {
  type        = string
  default     = ""
  description = "S3 bucket location containing the function's deployment package. Conflicts with filename"
}

variable "s3_key_prefix" {
  type        = string
  default     = ""
  description = "S3 object key prefix containing the function's deployment package. Conflicts with filename"
}

variable "runtimes" {
  type        = list(string)
  default     = ["python3.9"]
  description = "List of compatible runtimes of the Lambda layer, e.g. [python3.9]"
}

variable "architecture" {
  type    = string
  default = "x86_64"
  validation {
    condition     = contains(["arm64", "x86_64"], var.architecture)
    error_message = "The architecture value must be arm64 or x86_64"
  }
  description = "The type of computer processor that Lambda uses to run the function"
}
