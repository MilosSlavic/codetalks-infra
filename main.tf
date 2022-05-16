provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "github" {}

data "azurerm_client_config" "current" {}

module "azure" {
  source = "./azure"

  resource_group_name = "codetalks-rg"
  location = var.AZ_Location

  keyvault_name = "codetalks-keyvault"
  tenant_id = data.azurerm_client_config.current.tenant_id
  keyvault_sku = "standard"
  sp_id = data.azurerm_client_config.current.object_id
  user_id = var.user_object_id

  acr_name = "codetalksacr"
  acr_sku = "Premium"

  aks_name = "codetalks-aks"
  aks_dns_prefix = "codetalksaks"
  k8s_version = "1.23.5"
  aks_default_node_count = 1
  aks_default_vm_size = "Standard_D2_v2"
  aks_worker_pool_name = "ctpool01"
  aks_worker_node_count = 2
  aks_worker_vm_size = "Standard_DS2_v2"

  tags = var.tags
}

data "azurerm_storage_account" "proto_storage_account" {
  name = "codetalksprotostorage"
  resource_group_name = "codetalks-proto"
}

module "github" {
  source = "./github"

  acr_username = module.azure.acr_admin_username
  acr_password = module.azure.acr_admin_password
  proto_storage_account = data.azurerm_storage_account.proto_storage_account.primary_connection_string
  repository = "demo-hr"

  depends_on = [
    module.azure
  ]
}