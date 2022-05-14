output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password"{
    value = azurerm_container_registry.acr.admin_password
    sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}