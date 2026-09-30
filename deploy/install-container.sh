#!/usr/bin/env bash
set -euo pipefail
site_root=/var/www/maintainr-website
sudo mkdir -p "$site_root/deploy"
sudo install -m 644 /home/administrator/maintainr-container-nginx.conf "$site_root/deploy/container-nginx.conf"
sudo install -m 644 /home/administrator/maintainr-compose.yaml "$site_root/deploy/compose.yaml"
sudo docker compose -f "$site_root/deploy/compose.yaml" config --quiet
sudo docker compose -f "$site_root/deploy/compose.yaml" pull
sudo docker compose -f "$site_root/deploy/compose.yaml" run --rm --no-deps website nginx -t
sudo docker compose -f "$site_root/deploy/compose.yaml" up -d
sudo docker exec maintainr-website nginx -t
