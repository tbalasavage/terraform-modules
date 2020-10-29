terraform {
  required_version = ">= 0.13.0"
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name_prefix}-vm-neinterface-${var.name_suffix}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = var.subnet_id 
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = "${var.name_prefix}-vm-${var.name_suffix}"
  resource_group_name = var.rg.name
  location            = var.rg.location
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