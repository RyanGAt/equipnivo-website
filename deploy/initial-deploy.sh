#!/usr/bin/env bash
set -euo pipefail
release_id="${1:?Pass the published source commit SHA}"
[[ "$release_id" =~ ^[0-9a-f]{40}$ ]] || exit 1
site_root=/var/www/equipnivo-website
test ! -e "$site_root/current"
sudo mkdir -p "$site_root/releases/$release_id" "$site_root/deploy"
sudo tar -xzf /home/administrator/equipnivo-site.tar.gz -C "$site_root/releases/$release_id"
sudo chown -R root:www-data "$site_root/releases/$release_id"
sudo find "$site_root/releases/$release_id" -type d -exec chmod 755 {} +
sudo find "$site_root/releases/$release_id" -type f -exec chmod 644 {} +
sudo ln -s "$site_root/releases/$release_id" "$site_root/current"
sudo install -m 644 /home/administrator/equipnivo-compose.yaml "$site_root/deploy/compose.yaml"
sudo install -m 644 /home/administrator/equipnivo-container-nginx.conf "$site_root/deploy/container-nginx.conf"
sudo docker compose -f "$site_root/deploy/compose.yaml" config --quiet
sudo docker compose -f "$site_root/deploy/compose.yaml" run --rm --no-deps website nginx -t
sudo docker compose -f "$site_root/deploy/compose.yaml" up -d
sudo docker exec equipnivo-website nginx -t
printf '%s\n' "$release_id" | sudo tee "$site_root/deployed-commit.txt"
