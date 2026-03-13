resource "google_compute_instance" "web" {
  count        = var.web_server_count
  name         = "vladyslav-kotsiuba-im52mp-web${count.index + 1}"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "debian-cloud/debian-12" }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_web.sh", {
    db_ip        = google_compute_instance.db.network_interface.0.network_ip
    db_password  = var.db_password
    student_name = var.student_name
  })

  depends_on = [google_compute_instance.db]
}
