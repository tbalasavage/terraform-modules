variable "location" {
  type        = string
  default     = "East US"
  description = "Default location for resources"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the VM."
}

variable "admin_password" {
  type        = string
  description = "The password for the admin account."
}

variable "vnet" {
  type = object({
    name : string
    rg : string
    subnet_cidr : string
  })
}