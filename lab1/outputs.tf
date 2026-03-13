output "load_balancer_public_ip" {
  description = "Public IP address to verify the system is working"
  value       = azurerm_public_ip.lb_pip.ip_address
}
