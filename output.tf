output "vm_name" {
  description = "The name of the VM"
value = azurerm_windows_virtual_machine.vm.name
}
 
output "vm_ip_address" {
  description = "The private IP address of the VM"
  value       = azurerm_network_interface.nic.private_ip_address
}