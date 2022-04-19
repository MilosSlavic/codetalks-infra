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
  access_policy {
    tenant_id               = data.azurerm_client_config.current.tenant_id
    object_id               = data.azurerm_client_config.current.object_id
    key_permissions         = ["Get"]
    secret_permissions      = ["Get"]
    storage_permissions     = ["Get"]
    certificate_permissions = ["Get"]
  }
  tags = var.tags
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
  address_prefixes     = ["10.0.0.0/16"]
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_container_registry" "acr" {
  name                          = "codetalksacr"
  resource_group_name           = azurerm_resource_group.codetalks-rg.name
  location                      = azurerm_resource_group.codetalks-rg.location
  public_network_access_enabled = false
  sku                           = "Premium"
  zone_redundancy_enabled       = false

  network_rule_set {
    default_action = "Deny"
    virtual_network {
      action    = "Allow"
      subnet_id = azurerm_subnet.k8s-subnet.id
    }
  }

  tags = var.tags
}