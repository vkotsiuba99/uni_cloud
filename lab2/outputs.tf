output "load_balancer_public_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}
output "db1_internal_ip" {
  value = azurerm_network_interface.db_nic[0].ip_configuration[0].private_ip_address
}
output "db2_internal_ip" {
  value = azurerm_network_interface.db_nic[1].ip_configuration[0].private_ip_address
}
output "db3_internal_ip" {
  value = azurerm_network_interface.db_nic[2].ip_configuration[0].private_ip_address
}
