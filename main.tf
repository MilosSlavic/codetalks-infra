provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "codetalks-rg" {
  name     = "codetalks-rg"
  location = var.AZ_Location
  tags = var.tags
}