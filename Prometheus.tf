
resource "exoscale_compute" "mymachine" {
  zone         = var.zone
  display_name = "prometheus"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Micro"
  disk_size    = 10
  key_pair     = exoscale_ssh_keypair.rsa_ida.name

  affinity_groups = []
  security_groups = [exoscale_security_group.sg.name]

  #user_data = file("./UserData/prometheus.sh")
  user_data = templatefile("UserData/prometheus.sh", {
        exoscale_key = var.exoscale_key,
        exoscale_secret = var.exoscale_secret,
        exoscale_zone = var.zone,
        exoscale_instancepool_id = exoscale_instance_pool.instancepool.id
    })
}