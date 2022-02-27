variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  description = "Tag information to be assigned to resources created."
  type = object({
    product           = string
    cost_center       = string
    environment       = string
    region            = string
    owner             = string
    technical_contact = string
  })
}

variable "vm_size" {
  type        = string
  description = "VM size"
}

variable "vm_name" {
  type        = string
  description = "VM name"
}

variable "vnet_id" {
  description = "ID of the VNET where Vault VM will be installed"
  type        = string
}

variable "subnet_id" {
  type = string
}

// variable dns_zone_name {
//   description = "Private DNS Zone name to link Vault's vnet to"
//   type        = string
// }

// variable dns_zone_resource_group {
//   description = "Private DNS Zone resource group"
//   type        = string
// }


variable "vm_user" {
  description = "Vault VM user name"
  type        = string
  default     = "azureuser"
}
