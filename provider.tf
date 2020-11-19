terraform {
  required_providers {
    exoscale = {
      source  = "terraform-providers/exoscale"
    }
  }
}
variable "exoscale_key" {
  description = "The Exoscale API key"
  type = string
}
variable "exoscale_secret" {
  description = "The Exoscale API secret"
  type = string
}
variable "zone" {
  type = string
  default = "at-vie-1"
}
provider "exoscale" {
  key = var.exoscale_key
  secret = var.exoscale_secret
}