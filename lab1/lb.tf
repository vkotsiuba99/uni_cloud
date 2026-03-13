resource "google_compute_instance" "lb" {
  name         = "vladyslav-kotsiuba-im52mp-lb"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "debian-cloud/debian-12" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_lb.sh", {
    # Dynamically pass the list of IP addresses of all created web servers
    backend_ips = google_compute_instance.web[*].network_interface.0.network_ip
  })

  depends_on = [google_compute_instance.web]
}
