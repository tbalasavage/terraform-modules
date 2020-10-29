variable "name_prefix" {
  type        = string
  description = "The string of characters to add to the beginning of each resource created."
}

variable "name_suffix" {
  type        = string
  description = "The string of characters to add to the end of each resource created."
}

variable "rg" {
  type = object({
    name : string
    location : string
  })
  description = "The attributes about the resource group into which resources will be placed."
}

variable "admin_username" {
  type        = string
  description = "The admin username for the VM."
}

variable "admin_password" {
  type        = string
  description = "The password for the admin account."
}

variable "subnet_id" {
    type = string
    description = "The ID of the subnet for interface placement."
}