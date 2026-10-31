#!/usr/bin/env bash
# Bootstrap fresh Ubuntu server
set -e

echo "[*] Bootstrapping homelab server..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git rsync ufw htop net-tools ca-certificates

# Install Docker if not present
if ! command -v docker &> /dev/null; then
  echo "[*] Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker $USER
fi

# Install Docker Compose plugin if not present
if ! docker compose version &> /dev/null; then
  echo "[*] Installing Docker Compose plugin..."
  sudo apt install -y docker-compose-plugin
fi

echo "[✓] Bootstrap complete"
