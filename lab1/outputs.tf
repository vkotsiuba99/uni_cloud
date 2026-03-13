output "load_balancer_public_ip" {
  description = "Public IP address to verify the system is working"
  value       = google_compute_instance.lb.network_interface.0.access_config.0.nat_ip
}
