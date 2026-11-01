#!/usr/bin/env bash
# Fix permissions for all Docker volumes
set -e

echo "[*] Fixing permissions..."
USER_NAME="$(whoami)"
find ~/homelab/stacks -type d \( -name "data" -o -name "config" -o -name "cache" -o -name "workdir" -o -name "confdir" -o -name "ollama" -o -name "openwebui" -o -name "logs" -o -name "servers" \) 2>/dev/null | xargs -r sudo chown -R "$USER_NAME:$USER_NAME" 2>/dev/null || true
find ~/homelab/stacks -type d \( -name "data" -o -name "config" -o -name "cache" -o -name "workdir" -o -name "confdir" -o -name "ollama" -o -name "openwebui" -o -name "logs" -o -name "servers" \) 2>/dev/null | xargs -r sudo chmod -R u+rwX 2>/dev/null || true
echo "[+] Done"
