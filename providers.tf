terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.2.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.25.0-alpha"
    }
  }
}