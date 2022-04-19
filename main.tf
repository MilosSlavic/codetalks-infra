provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "codetalks-rg" {
  name     = "codetalks-rg"
  location = var.AZ_Location
  tags     = var.tags
}

resource "azurerm_key_vault" "codetalks-keyvault" {
  name                            = "codetalk-keyvault"
  location                        = azurerm_resource_group.codetalks-rg.location
  resource_group_name             = azurerm_resource_group.codetalks-rg.name
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  sku_name                        = "standard"
  access_policy                   = []
  tags                            = var.tags
}

resource "azurerm_key_vault_access_policy" "codetalks-keyvault-accesspolicy" {
  key_vault_id        = azurerm_key_vault.codetalks-keyvault.id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  key_permissions     = ["Get"]
  secret_permissions  = ["Get"]
  storage_permissions = ["Get"]
}

resource "azurerm_virtual_network" "codetalks-vnet" {
  name                = "codetalks-vnet"
  location            = azurerm_resource_group.codetalks-rg.location
  resource_group_name = azurerm_resource_group.codetalks-rg.name
  address_space       = ["10.0.0.0/8"]
  tags                = var.tags
}

resource "azurerm_subnet" "k8s-subnet" {
  name                 = "k8s-subnet"
  resource_group_name  = azurerm_resource_group.codetalks-rg.name
  virtual_network_name = azurerm_virtual_network.codetalks-vnet.name
  address_prefixes     = ["10.0.1.0/16"]
  service_endpoints = [ "Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage" ]
}