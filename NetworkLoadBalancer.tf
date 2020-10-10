resource "exoscale_nlb" "network_load_balancer" {
  name        = "network_load_balancer"
  description = "This is the Network Load Balancer for my website"
  zone        = var.zone
}

resource "exoscale_nlb_service" "network_load_balancer" {
  zone             = exoscale_nlb.network_load_balancer.zone
  name             = "network_load_balancer_service"
  description      = "Website over HTTP"
  nlb_id           = exoscale_nlb.network_load_balancer.id
  instance_pool_id = exoscale_instance_pool.instancepool.id
    protocol       = "tcp"
    port           = 80
    target_port    = 8080
    strategy       = "round-robin"

  healthcheck {
    mode     = "http"
    port     = 8080
    uri      = "/health"
    interval = 5
    timeout  = 3
    retries  = 1
  }
}