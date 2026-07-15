variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs apply as tags to all resources in the module"
}

variable "table_name" {
  type        = string
  description = "The table name"
}

variable "billing_mode" {
  type        = string
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST"
  default     = "PROVISIONED"
}

variable "read_capacity" {
  type        = number
  description = "Number of read units for this table. If the billing_mode is PROVISIONED, this field is required"
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required"
  default     = 5
}

variable "hash_key" {
  type        = string
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute"
}

variable "range_key" {
  type        = string
  description = "Attribute to use as the range (sort) key. Must also be defined as an attribute"
  nullable    = true
  default     = null
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Enable deletion protection for the table"
  default     = false
}

variable "global_secondary_indexes" {
  type = map(object({
    name            = string
    hash_key        = string
    key_type        = string
    read_capacity   = optional(number, 1)
    write_capacity  = optional(number, 1)
    projection_type = string
  }))
  description = "A map of global secondary indexes to create in the table"
  default     = {}
}

variable "stream_enabled" {
  type        = bool
  description = "Enable DynamoDB Streams for change data capture"
  default     = false
}

variable "stream_view_type" {
  type        = string
  description = "The type of data from the stream to be captured in the stream view. Only valid when stream_enabled is true"
  nullable    = true
  default     = "NEW_AND_OLD_IMAGES"
}
