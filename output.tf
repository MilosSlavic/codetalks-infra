output "client_certificate" {
  value     = module.azure
  sensitive = true
}

output "kube_config" {
  value     = module.azure.kube_config
  sensitive = true
}

output "acr_admin_username" {
  value     = module.azure.acr_admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = module.azure.acr_admin_password
  sensitive = true
}