output "vm_id" {
  value = azurerm_windows_virtual_machine.this.id
  description = "The ID Of the newly created virtual machine."
}