variable "zone" {
  default = "at-vie-1"
}

data "exoscale_compute_template" "ubuntu" {
  zone = var.zone
  name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_instance_pool" "instancepool" {
  name         = "instancepool"
  zone         = var.zone
  description = "david_instancepool"
  template_id  = data.exoscale_compute_template.ubuntu.id
  service_offering = "micro"
  size         = 2
  disk_size    = 10
  key_pair     = exoscale_ssh_keypair.rsa_ida.name
  security_group_ids = [exoscale_security_group.sg.id]
  user_data = file("./UserData/loadGenerator.sh")
}