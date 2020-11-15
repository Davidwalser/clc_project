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
variable "zone_id" {
  type = string
  default = "4da1b188-dcd6-4ff5-b7fd-bde984055548"
}
provider "exoscale" {
  key = var.exoscale_key
  secret = var.exoscale_secret
}