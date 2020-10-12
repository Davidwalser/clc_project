#!/bin/bash
set -e
apt update
apt-get update
# sudo apt-get remove docker docker-engine docker.io
apt install -y docker.io
docker run --restart=always -p 8080:8080 janoszen/http-load-generator:1.0.1