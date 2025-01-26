variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

# API Gateways
variable "endpoint_type" {
  type        = string
  default     = "EGDE"
  description = "The endpoint type. Must be one of REGIONAL or EGDE"
}
variable "swagger_file" {
  type        = string
  default     = "swagger.yaml"
  description = "The relative path of Swagger file according to current working directory"
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
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specific api gateway log group"
}

# variable "vpc_endpoint_id" {
#   type        = string
#   default     = ""
#   description = "VPC endpoint for private Rest API"
# }
