variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources"
  default     = {}
}

variable "env" {
  type        = string
  description = "The environment of project, such as dev, int, prod"
  default     = "dev"
}

variable "application_name" {
  type        = string
  description = "The nickname of project. Should be lowercase without special chars"
}

variable "billing_mode" {
  type        = string
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST"
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  type        = number
  description = "Number of read units for this table. If the billing_mode is PROVISIONED, this field is required"
  default     = 1
}

variable "write_capacity" {
  type        = number
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required"
  default     = 1
}
