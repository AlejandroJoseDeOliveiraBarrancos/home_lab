#!/usr/bin/env bash
# Make sudo passwordless for current user (homelab only - use with caution)
set -e

USER_NAME="$(whoami)"
SUDOERS_FILE="/etc/sudoers.d/010-${USER_NAME}-nopasswd"

echo "[*] Configuring passwordless sudo for ${USER_NAME}..."

echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" | sudo tee "${SUDOERS_FILE}" > /dev/null
sudo chmod 440 "${SUDOERS_FILE}"
sudo visudo -c

echo "[+] Passwordless sudo configured for ${USER_NAME}"
echo "[!] Only use this on trusted homelab machines"
