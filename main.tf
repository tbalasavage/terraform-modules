terraform {
  required_version = ">= 0.13.0"
  backend "azurerm" {
    key                  = "terraform.tfstate"
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstorage"
    container_name       = "buildagents-development"
  }
}

provider "azurerm" {
  version = "~>2.23.0"
  features {}
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet.name
  resource_group_name = var.vnet.rg
}

resource "azurerm_resource_group" "this" {
  name     = "buildagents-rg"
  location = var.location
}

resource "azurerm_subnet" "this" {
  name                 = "builagents-subnet"
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = [var.vnet.subnet_cidr]
}

module "windows_vm" {
  source = "./modules/windows_vm"
  
  name_prefix = "buildagent"
  name_suffix = "1"
  rg = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
  admin_username = var.admin_username
  admin_password = var.admin_password
  subnet_id = azurerm_subnet.this.id
}
