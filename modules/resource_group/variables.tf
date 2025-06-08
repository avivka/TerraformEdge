variable "name" {
  description = "The name of the existing resource group"
  type        = string
}

variable "lock" {
  description = "The lock configuration for the resource group"
  type = object({
    name  = optional(string)
    kind  = string # Can be "CanNotDelete", "ReadOnly", or "None"
    notes = optional(string)
  })
  default = {
    kind = "None"
  }
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "The lock kind must be one of: CanNotDelete, ReadOnly, None"
  }
}
