#!/bin/bash
set -e
apt update
apt-get update
apt install -y docker.io

#Prometheus config file
cat <<EOCF >/srv/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: Instances
    file_sd_configs:
      - files:
          - /srv/service-discovery/config.json
        refresh_interval: 10s
EOCF

docker volume create --name SharedDir

docker run \
    -d \
    -p 9090:9090 \
    -v SharedDir:/srv/service-discovery \
    -v /srv/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus

# docker run -d -v SharedDir:/var/run/prometheus-sd-exoscale-instance-pools janoszen/prometheus-sd-exoscale-instance-pools --exoscale-api-key ${exoscale_key} --exoscale-api-secret ${exoscale_secret} --exoscale-zone-id 4da1b188-dcd6-4ff5-b7fd-bde984055548 --instance-pool-id ${exoscale_instancepool_id} --prometheus-port 9100

docker run -d -v SharedDir:/srv/service-discovery -e EXOSCALE_KEY=${exoscale_key} -e EXOSCALE_SECRET=${exoscale_secret} -e EXOSCALE_ZONE=${exoscale_zone} -e EXOSCALE_INSTANCEPOOL_ID=${exoscale_instancepool_id} -e TARGET_PORT="9100" davidwalser/servicediscovery