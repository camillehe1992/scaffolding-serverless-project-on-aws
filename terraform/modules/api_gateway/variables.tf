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

# API Gateways

variable "openapi_json_file" {
  type        = string
  description = "The path of OpenAPI specification of API Gateway Rest API"
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

variable "rest_api_path" {
  type        = string
  default     = "/path1"
  description = "The path to create in the API Gateway RestA PI"
}

variable "api_gateway_log_retention_days" {
  type        = number
  default     = 30
  description = <<EOF
    Specifies the number of days you want to retain log events in the specific api gateway log group.
    Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653
  EOF
}

variable "vpc_endpoint_id" {
  type        = string
  description = "VPC endpoint for private Rest API"
}


