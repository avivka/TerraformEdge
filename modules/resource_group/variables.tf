variable "name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resource group should be created"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource group"
  type        = map(string)
  default     = {}
}

variable "prevent_resource_group_deletion" {
  description = "Should the resource group be protected from accidental deletion?"
  type        = bool
  default     = false
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
