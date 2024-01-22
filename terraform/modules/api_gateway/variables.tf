variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "resource_prefix" {
  type        = string
  description = "The prefix of resources name"
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
variable "name" {
  type        = string
  default     = "portal"
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
