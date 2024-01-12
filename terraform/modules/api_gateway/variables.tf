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

# API Gateways
variable "swagger_file" {
  type        = string
  description = "The path of Swagger specification of API Gateway Rest API"
}

variable "invoke_arn" {
  type        = string
  description = "ARN to be used for invoking Lambda Function from API Gateway"
}

variable "rest_api_description" {
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
  default     = "rest-api"
  description = "The name of API Gateway Rest API"
}

variable "log_retention_days" {
  type        = number
  default     = 30
  description = "Specifies the number of days you want to retain log events in the specific api gateway log group"
}

# variable "vpc_endpoint_id" {
#   type        = string
#   default     = ""
#   description = "VPC endpoint for private Rest API"
# }
