variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs apply as tags to all resources in the module"
}

variable "resource_prefix" {
  type        = string
  default     = ""
  description = "The prefix of resource name"
}

variable "name" {
  type        = string
  default     = ""
  description = "The table name"
}

variable "billing_mode" {
  type        = string
  default     = "PROVISIONED"
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST"
}

variable "read_capacity" {
  type        = number
  default     = 1
  description = "Number of read units for this table. If the billing_mode is PROVISIONED, this field is required"
}

variable "write_capacity" {
  type        = number
  default     = 1
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required"
}

variable "hash_key" {
  type        = string
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute"
}

variable "range_key" {
  type        = string
  default     = ""
  description = "Attribute to use as the range (sort) key. Must also be defined as an attribute"
}
