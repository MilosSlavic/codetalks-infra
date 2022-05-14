output "client_certificate" {
  value     = module.azure
  sensitive = true
}

output "kube_config" {
  value     = module.azure.kube_config
  sensitive = true
}