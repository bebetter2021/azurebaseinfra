output "vaultvm_ip" {
  description = "Vault VM IP"
  value       = azurerm_linux_virtual_machine.vaultvm.public_ip_address
}

output "vaultvm_username" {
  description = "Vault VM username"
  value       = var.vm_user
}

output "vaultvm_password" {
  description = "Vault VM admin password"
  value       = random_password.adminpassword.result
}
