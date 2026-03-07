variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
  default     = {}
}

# API Gateways
variable "endpoint_type" {
  type        = string
  description = "The endpoint type. Must be one of REGIONAL or EGDE"
  default     = "REGIONAL"
}
variable "swagger_file" {
  type        = string
  description = "The relative path of Swagger file according to current working directory"
  default     = "swagger.yaml"
}

variable "invoke_arn" {
  type        = string
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
}

variable "description" {
  type        = string
  default     = "Rest API for serverless project that triggers lambda function"
  description = "The description of API Gateway Rest API"
}
variable "stage_name" {
  type        = string
  default     = "v1"
  description = "The stage name of API Gateway Rest API"
}
variable "rest_api_name" {
  type        = string
  description = "The name of API Gateway Rest API"
  default     = "serverless-project-portal"
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specific api gateway log group"
  default     = 30
}

# variable "vpc_endpoint_id" {
#   type        = string
#   default     = ""
#   description = "VPC endpoint for private Rest API"
# }
