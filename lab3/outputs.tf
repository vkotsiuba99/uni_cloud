output "stor1_internal_ip" {
  value = azurerm_network_interface.stor_nic[0].ip_configuration[0].private_ip_address
}

output "stor2_internal_ip" {
  value = azurerm_network_interface.stor_nic[1].ip_configuration[0].private_ip_address
}

output "client_public_ip" {
  value = azurerm_public_ip.client_pip.ip_address
}
