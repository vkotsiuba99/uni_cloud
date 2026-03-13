resource "google_compute_network" "vpc_network" {
  name                    = "lab1-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3306"]
  }
  source_ranges = ["0.0.0.0/0"]
}
