#!/bin/bash
# set -e -> if an error occurs stop
set -e
apt update
apt-get update
# apt-get remove docker docker-engine docker.io
apt install -y docker.io

docker run -d --restart=always -p 8080:8080 janoszen/http-load-generator:1.0.1

docker run -d \
 --restart=always \
 --net="host" \
 --pid="host" \
 -v "/:/host:ro,rslave" \
 quay.io/prometheus/node-exporter \
 --path.rootfs=/host