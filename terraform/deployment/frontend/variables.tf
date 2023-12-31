# General deployment variables

variable "aws_region" {
  type        = string
  default     = "cn-north-1"
  description = "AWS region"
}

variable "aws_partition" {
  type        = string
  default     = "aws-cn"
  description = "AWS partition"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile which is used for the deployment"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "environment" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
}

variable "nickname" {
  type        = string
  description = "The nickname of project. Should be lowercase without special chars"
}

# API Gateway
variable "openapi_json_file" {
  type        = string
  default     = "../../../swagger/spec.yaml"
  description = "The path of OpenAPI specification of API Gateway Rest API"
}

variable "api_gateway_log_retention_days" {
  type        = number
  default     = 30
  description = <<EOF
    Specifies the number of days you want to retain log events in the specific api gateway log group.
    Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653
  EOF
}

variable "vpc_id" {
  type        = string
  description = "The VPC id associated with VPC endpoint for private Rest API"
}

# Lambda Functions
variable "lambda_function_memory_size" {
  type        = number
  description = "The memory size of Lambda function"
  default     = 128
}

variable "lambda_function_timeout" {
  type        = number
  description = "The timeout of Lambda function"
  default     = 10
}

variable "lambda_function_runtime" {
  type        = string
  description = "The runtime of Lambda function"
  default     = "python3.9"
}

variable "lambda_create_versions" {
  type        = bool
  default     = false
  description = "Publish a new version of Lambda each time the code changes"
}

variable "lambda_log_retention_days" {
  type        = number
  default     = 180
  description = <<EOF
    Specifies the number of days you want to retain log events in the specific lambda log group.
    Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653
  EOF
}

variable "log_level" {
  type        = string
  description = "The log level of Lambda function"
  default     = "debug"
}

variable "s3_bucket" {
  type        = string
  description = "The s3 bucket where the terraform state file locates in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for Lambda functions wich runs in a VPC"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group ids for Lambda functions wich runs in a VPC"
}

variable "api_gateway_vpc_endpoint_deployment" {
  type        = bool
  default     = false
  description = "Defines if the VPC endpoint for API Gateway will be deployed or not"
}
