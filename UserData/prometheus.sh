#!/bin/bash
set -e
apt update
apt-get update

#Prometheus config file
cat <<EOCF >/srv/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: Monitoring Server Node Exporter
    static_configs:
      - targets:
          - '1.2.3.4:9100'
  - job_name: Custom
    file_sd_configs:
      - files:
          - /service-discovery/custom_servers.json
        refresh_interval: 10s
EOCF

apt install -y docker.io
# Local: 
# docker run -d -p 9090:9090 -v "C:/Study/FH_Campus/Semester1/CLC/Exercise/prometheus.yml:/etc/prometheus/prometheus.yml" prom/prometheus
docker run -d -p 9090:9090 -v "/srv/prometheus.yml:/etc/prometheus/prometheus.yml" prom/prometheus