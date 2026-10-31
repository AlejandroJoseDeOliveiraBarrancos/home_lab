#!/usr/bin/env bash
# Install Docker Engine + Docker Compose plugin (idempotent)
set -e

echo "[*] Checking Docker installation..."

if command -v docker &> /dev/null && docker compose version &> /dev/null; then
  echo "[+] Docker and Docker Compose already installed"
  docker version | head -2
  docker compose version
  exit 0
fi

echo "[*] Updating apt and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

echo "[*] Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "[*] Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[*] Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[*] Adding $USER to docker group..."
sudo usermod -aG docker "$USER"

echo "[+] Docker installed successfully"
echo "[!] Log out and back in (or run 'newgrp docker') for group changes to take effect"
