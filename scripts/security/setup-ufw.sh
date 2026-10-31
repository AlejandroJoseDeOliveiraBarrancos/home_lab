#!/usr/bin/env bash
# Configure UFW for homelab (idempotent)
set -e

echo "[*] Configuring UFW firewall..."

sudo apt-get install -y ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

sudo ufw allow from 192.168.1.0/24 to any port 53 proto udp comment 'DNS UDP LAN'
sudo ufw allow from 192.168.1.0/24 to any port 53 proto tcp comment 'DNS TCP LAN'

sudo ufw --force enable
sudo ufw status verbose
