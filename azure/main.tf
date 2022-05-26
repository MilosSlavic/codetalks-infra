terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.2.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}


resource "azurerm_key_vault" "keyvault" {
  name                            = var.keyvault_name
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = true
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  sku_name                        = var.keyvault_sku

  access_policy {
    tenant_id               = var.tenant_id
    object_id               = var.sp_id
    key_permissions         = ["Get"]
    secret_permissions      = ["Get"]
    storage_permissions     = ["Get"]
    certificate_permissions = ["Get"]
  }

  access_policy {
    tenant_id               = var.tenant_id
    object_id               = var.user_id
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "UnwrapKey", "Sign", "WrapKey", "Decrypt", "Encrypt", "Purge", "Verify"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    storage_permissions     = ["Get"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
  }

  tags = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  public_network_access_enabled = true
  sku                           = var.acr_sku
  zone_redundancy_enabled       = false
  admin_enabled                 = true

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.k8s_version

  default_node_pool {
    name                 = "default"
    node_count           = var.aks_default_node_count
    vm_size              = var.aks_default_vm_size
    orchestrator_version = var.k8s_version
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_nodepool" {
  name                  = var.aks_worker_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  node_count            = var.aks_worker_node_count
  vm_size               = var.aks_worker_vm_size
  orchestrator_version  = var.k8s_version
  tags                  = var.tags

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}