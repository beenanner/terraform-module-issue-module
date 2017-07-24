variable "name" {}

variable "zones" {
  type = "list"
}

variable "instance_count" {}

variable "instance_type" {}

variable "image" {}

variable "subnetwork" {}

variable "subnetwork_project" {}

module "compute" {
  source = "./special-compute"

  name                  = "${var.name}-special"
  zones                 = "${var.zones}"
  instance_count        = "${var.instance_count}"
  instance_type         = "${var.instance_type}"
  subnetwork            = "${var.subnetwork}"
  subnetwork_project    = "${var.subnetwork_project}"
  image                 = "${var.image}"

}

resource "google_compute_instance" "compute" {
  name         = "${var.name}-basic-instance-1"
  count        = "1"
  machine_type = "${var.instance_type}"
  zone         = "${element(var.zones, count.index)}"

  disk {
    image = "ubuntu-1604-lts"
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
  value = ["${module.compute.instance_private_ips}"]
}
