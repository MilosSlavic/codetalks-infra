variable "AZ_Location" {
  type    = string
  default = "westeurope"
}

variable "tags" {
  type = map(string)
  default = {
    Source = "Terraform"
    Environment = "CodeTalks"
    Author = "Milos Slavic"
  }
}