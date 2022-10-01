locals {
  cluster_name = replace(lower("${var.tags.product}-${var.tags.region}-${var.tags.environment}"), " ", "_")

  tenant_id = var.az_tenant_id == "" ? data.azurerm_client_config.current.tenant_id : var.az_tenant_id
}
