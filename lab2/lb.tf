resource "google_compute_instance" "lb" {
  name         = "vladyslav-kotsiuba-im52mp-lb"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_lb.sh", {
    backend_ips = google_compute_instance.web[*].network_interface.0.network_ip
  })

  depends_on = [google_compute_instance.web]
}
