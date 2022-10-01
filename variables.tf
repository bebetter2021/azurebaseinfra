variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_DS1_v2"
}

variable "vm_name" {
  type        = string
  description = "VM name"
  default     = "tonyk8s"
}

variable "node_count" {
  type        = number
  description = "number of AKS nodes"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "cluster_admin_ids" {
  type        = list(any)
  description = "Object Ids for admn groups in cluster"
}

variable "subnet_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}
