output "stor1_internal_ip" { value = google_compute_instance.stor[0].network_interface.0.network_ip }
output "stor2_internal_ip" { value = google_compute_instance.stor[1].network_interface.0.network_ip }
output "client_public_ip" { value = google_compute_instance.client.network_interface.0.access_config.0.nat_ip }
