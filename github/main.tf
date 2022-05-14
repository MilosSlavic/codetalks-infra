terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.25.0-alpha"
    }
  }
}

resource "github_actions_secret" "acrusername" {
  secret_name     = "ACR_USERNAME"
  plaintext_value = var.acr_username
  repository      = var.repository
}

resource "github_actions_secret" "acrpass" {
  secret_name     = "ACR_PASSWORD"
  plaintext_value = var.acr_password
  repository      = var.repository
}