# General
variable "aws_region" {
  type        = string
  description = "AWS region which is used for the deployment"

}
variable "aws_profile" {
  type        = string
  default     = "default"
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
