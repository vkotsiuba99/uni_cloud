resource "google_compute_instance" "db" {
  count        = var.db_node_count
  name         = "vladyslav-kotsiuba-im52mp-db${count.index + 1}"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_db.sh", {
    db_password = var.db_password
    server_id   = count.index + 1
  })
}
