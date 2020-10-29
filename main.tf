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

resource "azurerm_resource_group" "this" {
  name     = "buildagents-rg"
  location = var.location
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet.name
  resource_group_name = var.vnet.rg
}

resource "azurerm_subnet" "this" {
  name                 = "builagents-subnet"
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = [var.vnet.subnet_cidr]
}

resource "azurerm_network_interface" "this" {
  name                = "buildagent-neinterface"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = "ba1-vm"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "rs5-pro"
    version   = "latest"
  }
}
