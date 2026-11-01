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

if [ -f "${HOMELAB_DIR}/scripts/security/disable-systemd-resolved-stub.sh" ]; then
  echo "[*] Configuring systemd-resolved for AdGuardHome..."
  bash "${HOMELAB_DIR}/scripts/security/disable-systemd-resolved-stub.sh" || true
  echo "[+] systemd-resolved configured"
fi

echo "[*] Fixing permissions on Docker volume data..."
USER_NAME="$(whoami)"
for dir in \
  "${HOMELAB_DIR}/stacks/core/nginx-proxy-manager/data" \
  "${HOMELAB_DIR}/stacks/core/nginx-proxy-manager/letsencrypt" \
  "${HOMELAB_DIR}/stacks/core/adguardhome/workdir" \
  "${HOMELAB_DIR}/stacks/core/adguardhome/confdir"; do
  if [ -d "$dir" ]; then
    sudo chown -R "$USER_NAME:$USER_NAME" "$dir" 2>/dev/null || true
  fi
done
echo "[+] Permissions fixed"

echo "[✓] All applies complete"

echo "[*] Fixing permissions on all Docker volume data..."
USER_NAME="$(whoami)"
find "${HOMELAB_DIR}/stacks" -type d \( -name "data" -o -name "config" -o -name "cache" -o -name "workdir" -o -name "confdir" -o -name "ollama" -o -name "openwebui" -o -name "logs" \) 2>/dev/null | while read d; do
  sudo chown -R "$USER_NAME:$USER_NAME" "$d" 2>/dev/null || true
done
echo "[+] All permissions fixed"

if [ -f "${HOMELAB_DIR}/scripts/apps/apply-app-configs.sh" ]; then
  echo "[*] Applying application configs..."
  bash "${HOMELAB_DIR}/scripts/apps/apply-app-configs.sh" || true
fi
