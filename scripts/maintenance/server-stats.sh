#!/usr/bin/env bash
# Show homelab server stats (battery, CPU, RAM, disk, temps)
set -e

echo "=== Homelab Server Stats ==="
echo

# Install dependencies if missing
MISSING_PKGS=()
command -v acpi >/dev/null 2>&1 || MISSING_PKGS+=("acpi")
command -v upower >/dev/null 2>&1 || MISSING_PKGS+=("upower")
command -v sensors >/dev/null 2>&1 || MISSING_PKGS+=("lm-sensors")
command -v htop >/dev/null 2>&1 || MISSING_PKGS+=("htop")

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
  echo "[*] Installing missing packages: ${MISSING_PKGS[*]}"
  sudo apt-get update -qq
  sudo apt-get install -y "${MISSING_PKGS[@]}" >/dev/null 2>&1 || true
  if command -v sensors >/dev/null 2>&1; then
    sudo sensors-detect --auto >/dev/null 2>&1 || true
  fi
  echo "[+] Packages installed"
  echo
fi

echo "=== System ==="
hostnamectl | grep -E "Static hostname|Operating System|Kernel"
uptime
echo

echo "=== Battery ==="
if [ -d /sys/class/power_supply/BAT0 ] || [ -d /sys/class/power_supply/BAT1 ]; then
  for bat in /sys/class/power_supply/BAT*; do
    [ -f "$bat/capacity" ] && echo "Battery: $(cat $bat/capacity)%" || true
    [ -f "$bat/status" ] && echo "Status: $(cat $bat/status)" || true
  done
  acpi -b 2>/dev/null || true
  upower -i $(upower -e 2>/dev/null | grep BAT | head -1) 2>/dev/null | grep -E "state|percentage|time to|energy-rate" || true
else
  echo "No battery detected (likely desktop)"
fi
echo

echo "=== CPU ==="
echo "Load Average: $(cat /proc/loadavg | awk '{print $1,$2,$3}')"
grep -m1 "cpu MHz" /proc/cpuinfo | awk '{print "CPU Freq: " $4 " MHz"}'
sensors 2>/dev/null | grep -A 5 "Core" | head -10 || true
echo

echo "=== Memory ==="
free -h
echo

echo "=== Disk ==="
df -h / | tail -1
echo

echo "=== Network ==="
ip -4 addr show wlp2s0 2>/dev/null | grep inet || ip -4 addr show | grep inet | head -1
echo
