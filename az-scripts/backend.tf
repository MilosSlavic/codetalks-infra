terraform {
  backend "azurerm"{
      resource_group_name = "${var.AZ_ResourceGroupName}"
      storage_account_name = "${var.AZ_StorageAccountName}"
      container_name = "tfplan"
      key = "codetalks.terraform.tfstate"
  }
}