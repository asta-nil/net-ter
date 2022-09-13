variable "resource_group_name" {
  type = string
  description = "Name of resource group"
}

variable "location" {
  type = string
  description = "location for deployment"
}

variable "subnet_id" {
  type = number
  description = "Subnet id"
}

variable "public_ip_address_id" {
  type = number
  description = "public ip of virtual machine"
}