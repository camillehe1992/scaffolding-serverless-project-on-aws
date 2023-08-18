variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "api_gateway_vpc_endpoint_deployment" {
  type        = bool
  default     = false
  description = "Defines if the VPC endpoint for API Gateway will be deployed or not"
}

variable "vpc_id" {
  type        = string
  description = "The Id of the VPC we want to associate with the VPC Endpoint"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for Lambda functions wich runs in a VPC"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group ids for Lambda functions wich runs in a VPC"
}
