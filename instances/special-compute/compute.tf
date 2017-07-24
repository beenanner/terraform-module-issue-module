variable "image" {}

resource "google_compute_instance" "compute" {
  name         = "special-instance-1"
  count        = "1"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  disk {
    image = "${var.image}"
  }

  network_interface {
    subnetwork = "default"

    access_config {
      # ephemeral
    }
  }
}

output "instance_private_ips" {
  value = ["${google_compute_instance.compute.*.network_interface.0.address}"]
}
