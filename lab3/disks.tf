resource "google_compute_disk" "disk1" {
  count = 2
  name  = "vladyslav-kotsiuba-im52mp-disk1-node${count.index + 1}"
  type  = "pd-standard"
  size  = 2 # 2 GB to save resources
  zone  = var.zone
}

resource "google_compute_disk" "disk2" {
  count = 2
  name  = "vladyslav-kotsiuba-im52mp-disk2-node${count.index + 1}"
  type  = "pd-standard"
  size  = 2
  zone  = var.zone
}
