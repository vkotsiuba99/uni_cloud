resource "google_compute_instance" "client" {
  name         = "vladyslav-kotsiuba-im52mp-client"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_client.sh", {
    stor1_ip     = google_compute_instance.stor[0].network_interface.0.network_ip
    student_name = var.student_name
  })

  depends_on = [google_compute_instance.stor]
}
