#!/usr/bin/env bash
set -e
echo "[*] Disabling systemd-resolved stub listener..."
sudo sed -i "s/^#DNSStubListener=.*/DNSStubListener=no/" /etc/systemd/resolved.conf 2>/dev/null || true
sudo sed -i "s/^DNSStubListener=yes/DNSStubListener=no/" /etc/systemd/resolved.conf 2>/dev/null || true
grep -q "^DNSStubListener=no" /etc/systemd/resolved.conf || echo "DNSStubListener=no" | sudo tee -a /etc/systemd/resolved.conf >/dev/null
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf >/dev/null
sudo systemctl restart systemd-resolved 2>/dev/null || true
echo "[+] Done"
