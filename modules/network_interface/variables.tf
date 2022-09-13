variable "prefix" {
  default="netframe"
}

variable "resource_group_name" {
  type = string
  description = "Name of resource group"
}

variable "location" {
  type = string
  description = "location for deployment"
}

variable "subnet_id" {
  type = string
  description = "Subnet id"
}

variable "public_ip_address_id" {
  type = string
  description = "public ip of virtual machine"
}