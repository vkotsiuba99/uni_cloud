output "load_balancer_public_ip" {
  value = google_compute_instance.lb.network_interface.0.access_config.0.nat_ip
}
output "db1_internal_ip" {
  value = google_compute_instance.db[0].network_interface.0.network_ip
}
output "db2_internal_ip" {
  value = google_compute_instance.db[1].network_interface.0.network_ip
}
output "db3_internal_ip" {
  value = google_compute_instance.db[2].network_interface.0.network_ip
}
