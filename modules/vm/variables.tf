variable resource_group {
  type = string
}

variable location {
  type = string
}

variable vnet_id {
  description = "ID of the VNET where Vault VM will be installed"
  type        = string
}

variable subnet_id {
  description = "ID of subnet where Vault VM will be installed"
  type        = string
}

variable dns_zone_name {
  description = "Private DNS Zone name to link Vault's vnet to"
  type        = string
}

variable dns_zone_resource_group {
  description = "Private DNS Zone resource group"
  type        = string
}


variable vm_user {
  description = "Vault VM user name"
  type        = string
  default     = "azureuser"
}