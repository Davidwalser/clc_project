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

# Local: 
# docker run -d -p 9090:9090 -v "C:/Study/FH_Campus/Semester1/CLC/Exercise/prometheus.yml:/etc/prometheus/prometheus.yml" prom/prometheus
docker run \
    -d \
    -p 9090:9090 \
    -v SharedDir:/srv/service-discovery/ \
    -v /srv/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus

# docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter --path.rootfs=/host

docker run \
    -d \
    -v SharedDir:/srv/service-discovery/ \
    -e EXOSCALE_KEY=${exoscale_key} \
    -e EXOSCALE_SECRET=${exoscale_secret} \
    -e EXOSCALE_ZONE=${exoscale_zone} \
    -e EXOSCALE_INSTANCEPOOL_ID=${exoscale_instancepool_id} \
    -e TARGET_PORT=9100 \
    deitsch/exoscale_sd

# docker run \
#     -d \
#     -v SharedDir:/srv/service-discovery/ \
#     -e EXOSCALE_KEY=EXOce2be1bb2452797f99e60192 \
#     -e EXOSCALE_SECRET=0prvtKfI7W-TteqUGwzV3bv2yOO2ZCqevaFy_7sTh4s \
#     -e EXOSCALE_ZONE=at-vie-1 \
#     -e EXOSCALE_INSTANCEPOOL_ID=instancepool \
#     -e TARGET_PORT=9100 \
#     deitsch/exoscale_sd

# docker run \
#     # Run in background
#     -d
#     # Mount the data directory
#     -v /srv/service-discovery:/var/run/prometheus-sd-exoscale-instance-pools \
#     janoszen/prometheus-sd-exoscale-instance-pools \
#     # Provide the Exoscale API key here:
#     --exoscale-api-secret ${exoscale_secret} \
#     # And the secret:
#     --exoscale-api-key ${exoscale_key} \
#     # Run the `exo zone` command to get this value
#     --exoscale-zone-id ${exoscale_zone} \
#     # Run the `exo instancepool list` command to get this value:
#     --instance-pool-id ${exoscale_instancepool_id}
#     # Provide the Prometheus service port
#     --port 9100