provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "baseinfra" {
  name     = "baseinfra"
  location = local.tags.region
  tags     = local.tags
}

module "vaultvm" {
  source         = "./modules/vm"
  tags           = local.tags
  resource_group = azurerm_resource_group.baseinfra.name
  subnet_id      = azurerm_subnet.baseinfra.id
  vm_size        = var.vm_size
  vm_name        = var.vm_name
  vnet_id        = azurerm_virtual_network.baseinfra.id
  location       = local.tags.region
}
