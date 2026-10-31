#!/usr/bin/env bash
# Single idempotent apply script for all homelab configs
set -e

HOMELAB_DIR="${HOME}/homelab"
PUB_KEY=""

for candidate in \
  "${HOMELAB_DIR}/inventory/server.pub" \
  "${HOMELAB_DIR}/inventory/homelab-server.pub"; do
  if [ -f "$candidate" ]; then
    PUB_KEY="$candidate"
    break
  fi
done

echo "[*] Starting homelab apply..."

if [ -n "$PUB_KEY" ]; then
  echo "[*] Ensuring SSH key is authorized using $(basename "$PUB_KEY")..."
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  if [ ! -f ~/.ssh/authorized_keys ] || ! grep -qxF "$(cat "$PUB_KEY")" ~/.ssh/authorized_keys 2>/dev/null; then
    cat "$PUB_KEY" >> ~/.ssh/authorized_keys
  fi
  chmod 600 ~/.ssh/authorized_keys
  echo "[+] SSH key authorized"
else
  echo "[!] No public key found in inventory/, skipping SSH key install"
fi

if [ -f "${HOMELAB_DIR}/configs/netplan/01-static-ip.yaml" ]; then
  echo "[*] Applying netplan..."
  sudo cp "${HOMELAB_DIR}/configs/netplan/01-static-ip.yaml" /etc/netplan/01-static-ip.yaml
  sudo chmod 600 /etc/netplan/01-static-ip.yaml
  sudo chown root:root /etc/netplan/01-static-ip.yaml
  sudo netplan apply || true
  echo "[+] Netplan applied"
fi

if [ -f "${HOMELAB_DIR}/configs/systemd/logind.conf" ]; then
  echo "[*] Applying logind config..."
  sudo cp "${HOMELAB_DIR}/configs/systemd/logind.conf" /etc/systemd/logind.conf
  sudo systemctl restart systemd-logind || true
  echo "[+] logind applied"
fi

echo "[✓] All applies complete"
