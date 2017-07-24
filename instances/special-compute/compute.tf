variable "name" {}

variable "zones" {
  type = "list"
}

variable "instance_count" {}

variable "instance_type" {}

variable "image" {}

variable "subnetwork" {}

variable "subnetwork_project" {}

resource "google_compute_instance" "compute" {
  name         = "${var.name}-instance-${count.index+1}"
  count        = "${var.instance_count}"
  machine_type = "${var.instance_type}"
  zone         = "${element(var.zones, count.index)}"

  disk {
    image = "${var.image}"
  }

  network_interface {
    subnetwork = "${var.subnetwork}"
    subnetwork_project = "${var.subnetwork_project}"

    access_config {
      # ephemeral
    }
  }
}

output "instance_private_ips" {
  value = ["${google_compute_instance.compute.*.network_interface.0.address}"]
}
