output "vm_ips" {
  value = azurerm_linux_virtual_machine.vm[*].public_ip_address
}

output "public_ips" {
  value = azurerm_public_ip.pip[*].ip_address
}
