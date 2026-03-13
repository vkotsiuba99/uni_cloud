resource "google_compute_network" "vpc_network" {
  name                    = "lab3-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_internal_gluster" {
  name    = "allow-internal-gluster"
  network = google_compute_network.vpc_network.name
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  source_ranges = ["10.128.0.0/9"] # GlusterFS requires open ports between nodes
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
