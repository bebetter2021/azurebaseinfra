resource "azurerm_public_ip" "pip" {
  name                = "vm-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "vm_sg" {
  name                = "vm-sg"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "vmNicConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "sg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_sg.id
}

resource "random_password" "adminpassword" {
  keepers = {
    resource_group = var.resource_group
  }

  length      = 10
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

resource "azurerm_linux_virtual_machine" "vaultvm" {
  name                            = "vaultvm"
  location                        = var.location
  resource_group_name             = var.resource_group
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  size                            = var.vm_size
  computer_name                   = "vaultvm"
  admin_username                  = var.vm_user
  admin_password                  = random_password.adminpassword.result
  disable_password_authentication = false

  os_disk {
    name                 = "vaultOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04.0-LTS"
    version   = "latest"
  }

  provisioner "remote-exec" {
    connection {
      host     = self.public_ip_address
      type     = "ssh"
      user     = var.vm_user
      password = random_password.adminpassword.result
    }

    inline = [
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "sudo apt-add-repository 'deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main'",
      "sudo apt-get update",
      "sudo snap install vault"
    ]
  }
}

// resource "azurerm_private_dns_zone_virtual_network_link" "hublink" {
//   name                  = "hubnetdnsconfig"
//   resource_group_name   = var.dns_zone_resource_group
//   private_dns_zone_name = var.dns_zone_name
//   virtual_network_id    = var.vnet_id
// }
