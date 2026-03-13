resource "google_compute_instance" "stor" {
  count        = 2
  name         = "vladyslav-kotsiuba-im52mp-stor${count.index + 1}"
  machine_type = var.machine_type
  
  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  # Attach the created disks (they will appear as /dev/sdb and /dev/sdc)
  attached_disk { source = google_compute_disk.disk1[count.index].id }
  attached_disk { source = google_compute_disk.disk2[count.index].id }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/scripts/init_storage.sh", {})
}
