#Configure the azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}


provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "northeurope"

}