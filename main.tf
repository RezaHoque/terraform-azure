#Configure the azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  # this is to keep the state file in azure storage account
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstateilyoc"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
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
  tags = {
    "environment" = "dev"
    "source"      = "Terraform"
  }
}

#creating linux app service plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "app-asp-${azurerm_resource_group.rg.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

#creating app service
resource "azurerm_app_service" "appservice" {
  name                = "appservice-${azurerm_resource_group.rg.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.appserviceplan.id
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    #settings for private docker registry
    /*
    DOCKER_REGISTRY_SERVER_URL           = "https://index.docker.io"
    DOCKER_REGISTRY_SERVER_USERNAME      = "ilyas"
    DOCKER_REGISTRY_SERVER_PASSWORD      = "ilyas"
    */
  }
  # Configure Docker Image to load on start
  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|appsvcsample/static-site:latest"
    dotnet_framework_version = "v5.0"
  }
  identity {
    type = "SystemAssigned"
  }
}

#creating azure container registry
resource "azurerm_container_registry" "acr" {
  name = "acrToDoRgTerraform"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku = "Basic"
  admin_enabled = true
  tags = {
    "environment" = "dev"
    "source"      = "Terraform"
  }
  
}