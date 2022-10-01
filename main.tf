provider "azurerm" {
  features {}
}

#Network begin

resource "azurerm_virtual_network" "k8sinfra" {
  name                = var.vnet_name
  location            = local.tags.region
  resource_group_name = azurerm_resource_group.k8sinfra.name
  address_space       = ["10.0.1.0/24"]
  tags                = local.tags
}

resource "azurerm_subnet" "k8sinfra" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.k8sinfra.name
  virtual_network_name = azurerm_virtual_network.k8sinfra.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "k8sinfra" {
  name                = "nsg-k8sinfra"
  location            = local.tags.region
  resource_group_name = azurerm_resource_group.k8sinfra.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "k8sinfra" {
  for_each                    = local.nsg_rules
  name                        = each.key
  priority                    = each.value["priority"]
  direction                   = each.value["direction"]
  access                      = each.value["access"]
  protocol                    = each.value["protocol"]
  source_port_range           = each.value["source_port_range"]
  destination_port_range      = each.value["destination_port_range"]
  source_address_prefix       = each.value["source_address_prefix"]
  destination_address_prefix  = each.value["destination_address_prefix"]
  resource_group_name         = azurerm_resource_group.k8sinfra.name
  network_security_group_name = azurerm_network_security_group.k8sinfra.name
}

# Network END


resource "tls_private_key" "aks_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_resource_group" "k8sinfra" {
  name     = "k8sinfra"
  location = local.tags.region
  tags     = local.tags
}

# data "azurerm_subnet" "k8sinfra" {
#   name = "k8ssub"
#   resource_group_name = var.subnet_name
#   virtual_network_name = var.vnet_name
# }

# module "vaultvm" {
#   source         = "./modules/vm"
#   tags           = local.tags
#   resource_group = azurerm_resource_group.k8sinfra.name
#   subnet_id      = azurerm_subnet.k8sinfra.id
#   vm_size        = var.vm_size
#   vm_name        = var.vm_name
#   vnet_id        = azurerm_virtual_network.k8sinfra.id
#   location       = local.tags.region
# }


module "aks" {
  source             = "./modules/aks"
  tags               = local.tags
  subnet_id          = azurerm_subnet.k8sinfra.id
  node_count         = var.node_count
  kubernetes_version = var.kubernetes_version
  location           = local.tags.region
  dns_prefix         = var.dns_prefix
  linux_profile = {
    sshkey   = tls_private_key.aks_key.public_key_openssh
    username = "adminuser"
  }
  cluster_admin_ids = var.cluster_admin_ids
  resource_group    = azurerm_resource_group.k8sinfra

  depends_on = [
    azurerm_resource_group.k8sinfra
  ]
}
