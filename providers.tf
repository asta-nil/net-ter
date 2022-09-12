terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
  backend "azurerm" {
    resource_group_name     = "cloud-shell-storage-westeurope"
    storage_account_name    = "csb100320022982d2df"
    container_name          = "workspacecloudshellstoragewesteuropeb127"
    key                     = "hello-world"
  }
}

provider "azurerm" {
  features {}
}