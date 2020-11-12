
resource "exoscale_compute" "mymachine" {
  zone         = "at-vie-1"
  display_name = "prometheus"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Micro"
  disk_size    = 10
  key_pair     = exoscale_ssh_keypair.rsa_ida.name

  affinity_groups = []
  security_groups = [exoscale_security_group.sg.name]

  user_data = file("./UserData/prometheus.sh")
}