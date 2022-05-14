variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "keyvault_sku" {
  type = string
}

variable "sp_id" {
  type = string
}

variable "user_id" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "acr_sku" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "aks_default_node_count" {
  type = number
}

variable "aks_default_vm_size" {
  type = string
}

variable "aks_worker_pool_name" {
  type = string
}

variable "aks_worker_node_count" {
  type = number
}

variable "aks_worker_vm_size" {
  type = string
}

variable "tags" {
  type = map(string)
}