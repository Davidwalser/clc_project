data "exoscale_compute_template" "ubuntu" {
  zone = "at-vie-1"
  name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_compute" "mymachine" {
  zone         = "at-vie-1"
  display_name = "test"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Micro"
  disk_size    = 10
  key_pair     = ""

  affinity_groups = []
  security_groups = [exoscale_security_group.sg.name]

  user_data = <<EOF
#!/bin/bash
set -e
apt update
apt install -y nginx
EOF
}