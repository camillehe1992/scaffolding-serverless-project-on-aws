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

variable "lambda_functions_specs" {
  type = map(object({
    description           = string
    memory_size           = number
    timeout               = number
    runtime               = string
    publish               = bool
    source_dir_path       = string
    source_file_path      = string
    output_file_path      = string
    handler               = string
    layers_arns           = list(string)
    role_arn              = string
    log_retention_days    = number
    environment_variables = map(string)
    permissions = map(object({
      statement_id = string
      principal    = string
      source_arn   = string
    }))
    event_sources = map(object({
      enabled           = bool
      batch_size        = number
      starting_position = string
      source_arn        = string
    }))

    subnet_ids         = list(string)
    security_group_ids = list(string)
  }))
}

variable "max_age_for_dynamo_records_in_sec" {
  type        = number
  default     = 604800
  description = <<EOF
    The maximum age of a record that Lambda sends to a function for processing. 
    Only available for stream sources (DynamoDB and Kinesis). Minimum of 60, maximum and default of 604800.
  EOF
}

variable "max_retry_for_dynamo_records" {
  type        = number
  default     = null
  description = <<EOF
    The maximum number of times to retry when the function returns an error. 
    Only available for stream sources (DynamoDB and Kinesis). Minimum of 0, maximum and default of 10000.(-1)
  EOF
}
