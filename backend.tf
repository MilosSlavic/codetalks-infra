terraform {
  required_version = ">=1.1.8"

  backend "azurerm" {
    resource_group_name  = "codetalks-terraform-rg"
    storage_account_name = "codetalksterraformsa"
    container_name       = "tfplan"
    key                  = "codetalks.terraform.tfstate"
  }
}