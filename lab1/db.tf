resource "google_compute_instance" "db" {
  name         = "vladyslav-kotsiuba-im52mp-db"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "debian-cloud/debian-12" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_db.sh", {
    db_password = var.db_password
  })
}
