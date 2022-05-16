variable "acr_username" {
  type = string
  sensitive = true
}

variable "acr_password" {
  type = string
  sensitive = true
}

variable "repository" {
  type = string
}

variable "proto_storage_account" {
  type = string
  sensitive =true
}