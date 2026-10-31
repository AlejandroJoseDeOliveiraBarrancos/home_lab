# Current Homelab State

All configurations from troubleshooting session are now tracked.

## Infrastructure
- **Server**: adeoliveira@192.168.1.8 (static IP, WiFi wlp2s0)
- **SSH**: Key-based auth via `inventory/homelab-server`
- **Network**: Netplan static config, lid-close disabled
- **Firewall**: UFW enabled (22, 80, 443 from anywhere, 53 from LAN)

## Services (Docker)
- **Nginx Proxy Manager** (port 81 admin, 80/443) - Reverse proxy on `proxy` network
- **AdGuardHome** (port 53 DNS, UI proxied via NPM) - DNS filtering, web UI at `adguard.home.local`
- **Tailscale** - Secure remote access configured

## DNS Setup
- Windows PC uses `192.168.1.8` as DNS (manually configured)
- AdGuardHome listens on port 53 (systemd-resolved stub listener disabled)
- UI accessible via NPM proxy or direct after setup

## Quick Commands
```bash
make test        # Test SSH
make up          # Start all services
make down        # Stop all services
make status      # Check server status
make firewall    # Apply UFW rules
make tailscale-up # Setup Tailscale
```
