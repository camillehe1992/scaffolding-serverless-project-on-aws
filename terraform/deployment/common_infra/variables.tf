# General deployment variables

variable "aws_region" {
  type        = string
  default     = "cn-north-1"
  description = "AWS region"
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

# IAM Roles and Policies

variable "api_gateway_role_deployment" {
  type        = bool
  default     = true
  description = "Defines if the API Gateway Role will be deployed or not. Use false if you have already a API Gateway Role deployed in your AWS account"
}

variable "api_gateway_role_name" {
  type        = string
  default     = "apigateway-logs-role"
  description = "Name of IAM role which dictates what other AWS services the API Gateway may access"
}

variable "api_gateway_role_description" {
  type        = string
  default     = "Allows API Gateway to write over CloudWatch"
  description = "Description of IAM role which dictates what other AWS services the API Gateway may access"
}

variable "api_gateway_policy_name" {
  type        = string
  default     = "apigateway-policy"
  description = "Name of IAM policy which dictates what other AWS services the API Gateway may access"
}

variable "lambda_role_name" {
  type        = string
  default     = "lambda-execution-role"
  description = "Name of IAM role which dictates what other AWS services the Lambda function may access"
}

variable "lambda_role_description" {
  type        = string
  default     = "IAM role for Lambda to execute specific tasks"
  description = "Description of IAM role which dictates what other AWS services the Lambda function may access"
}

variable "lambda_policy_name" {
  type        = string
  default     = "lambda-execution-policy"
  description = "Name of IAM policy which dictates what other AWS services the Lambda function may access"
}
