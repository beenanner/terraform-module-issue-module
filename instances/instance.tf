variable "image" {}

variable "instance_count" { default = 1}

module "compute" {
  source = "./special-compute"
  image                 = "${var.image}"

}

resource "google_compute_instance" "compute" {
  name         = "basic-instance-1"
  count        = "${var.instance_count}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  disk {
    image = "ubuntu-1604-lts"
  }

  network_interface {
    subnetwork = "default"
  }
}

output "instance_private_ips" {
  value = ["${module.compute.instance_private_ips}", "${google_compute_instance.compute.*.network_interface.0.address}"]
}
