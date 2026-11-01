#!/usr/bin/env bash
set -e

HOMELAB_DIR="${HOME}/homelab"

echo "[*] Applying app configurations..."

# Homepage
if [ -d "${HOMELAB_DIR}/stacks/apps/homepage/config" ] && [ -d "${HOMELAB_DIR}/configs/apps/homepage" ]; then
  cp "${HOMELAB_DIR}/configs/apps/homepage/"*.yaml "${HOMELAB_DIR}/stacks/apps/homepage/config/" 2>/dev/null || true
  echo "[+] Homepage config applied"
fi

# Fix permissions
echo "[*] Fixing permissions..."
USER_NAME="$(whoami)"
find "${HOMELAB_DIR}/stacks" -type d \( -name "data" -o -name "config" -o -name "cache" -o -name "workdir" -o -name "confdir" -o -name "ollama" -o -name "openwebui" -o -name "logs" -o -name "servers" \) 2>/dev/null | xargs -r sudo chown -R "$USER_NAME:$USER_NAME" 2>/dev/null || true

docker restart homepage 2>/dev/null || true
echo "[✓] App configs applied"
