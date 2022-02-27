provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "baseinfra" {
  name     = "baseinfra"
  location = local.tags.region
  tags     = local.tags
}