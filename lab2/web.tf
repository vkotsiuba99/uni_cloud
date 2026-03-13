resource "google_compute_instance" "web" {
  count        = var.web_node_count
  name         = "vladyslav-kotsiuba-im52mp-web${count.index + 1}"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_web.sh", {
    db_password  = var.db_password
    student_name = var.student_name
    primary_db_ip = google_compute_instance.db[0].network_interface.0.network_ip
  })

  depends_on = [google_compute_instance.db]
}
