variable "aws_region" {
  type        = string
  default     = "cn-north-1"
  description = "AWS region"
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

variable "lambda_role_name" {
  type        = string
  description = "Name of IAM role which dictates what other AWS services the Lambda function may access"
}

variable "lambda_role_description" {
  type        = string
  description = "Description of IAM role which dictates what other AWS services the Lambda function may access"
}

variable "lambda_policy_name" {
  type        = string
  description = "Name of IAM policy which dictates what other AWS services the Lambda function may access"
}

variable "lambda_policy_attachment_arns" {
  type        = list(string)
  default     = []
  description = "The list of the policy arn needs to be attached to the lambda role"
}

variable "api_gateway_role_deployment" {
  type        = bool
  default     = true
  description = "Defines if the API Gateway Role will be deployed or not. Use false if you have already a API Gateway Role deployed in your AWS account"
}

variable "api_gateway_role_name" {
  type        = list(string)
  description = "Name of IAM role which dictates what other AWS services the API Gateway may access"
}

variable "api_gateway_role_description" {
  type        = list(string)
  description = "Description of IAM role which dictates what other AWS services the API Gateway may access"
}

variable "api_gateway_policy_name" {
  type        = string
  description = "Name of IAM policy which dictates what other AWS services the API Gateway may access"
}

variable "api_gateway_policy_attachment_arns" {
  type        = list(string)
  default     = []
  description = "The list of the policy arn needs to be attached to the API Gateway role"
}
