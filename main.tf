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

# Generate a random integer to create a globally unique name
#resource "random_integer" "ri" {
 # min = 10000
  #max = 99999
#}

#creating resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "northeurope"

}

#creating linus app service plan
resource "azurerm_service_plan" "appserviceplan" {
  name = "app-asp-${azurerm_resource_group.rg.name}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type = "Linux"
  sku_name = "B1"
}
