output "vaultvm_ip" {
  description = "Vault VM IP"
  value       = module.vaultvm.vaultvm_ip
}

output "vaultvm_username" {
  description = "Vault VM username"
  value       = module.vaultvm.vaultvm_username
}

output "vaultvm_password" {
  description = "Vault VM admin password"
  value       = module.vaultvm.vaultvm_password
  sensitive   = true
}
