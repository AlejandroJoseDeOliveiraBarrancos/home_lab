# Homelab Configuration Management

This repository tracks infrastructure configuration for a repurposed old laptop acting as a homelab server.

## Quick Start

1. Update `.env` with your server details (run `ip a` on server to find interface name)
2. Run `make push` to sync configs to server
3. Run `make apply-ip` to set static IP
4. Run `make apply-lid` to prevent lid-close suspension
5. Run `make ssh` to connect

## Available Commands

- `make init` - Create config directories on remote server
- `make push` - Sync configuration files to server via rsync
- `make ssh` - SSH into the server
- `make apply-ip` - Copy netplan config and apply it
- `make apply-lid` - Copy logind.conf and restart systemd-logind
- `make status` - Check hostname and interface status
- `make connect-test` - Test SSH connectivity

## Future Roadmap

This repo is structured to grow into a full configuration management system. Planned services:

- **Networking & Security**: Pi-hole/AdGuard, Nginx Proxy Manager/Traefik/Caddy, Tailscale/WireGuard, CrowdSec, Step-CA
- **Media & Storage**: Jellyfin/Plex, Syncthing, file sharing
- **Apps & Services**: Homepage/Homarr dashboard, Vaultwarden, Authelia, Ollama + Open WebUI
- **Game Servers**: Pterodactyl/LinuxGSM, Minecraft
- **Monitoring/Alerts**: Gotify/Ntfy, backups with Kopia/Duplicati
- **VPN Routing**: Gluetun for containerized VPN

## Notes

- Always update interface name in `.env`, `netplan/01-static-ip.yaml`, and `Makefile` context
- Netplan changes may drop connectivity - have console access ready
- Git tracks all configs - commit changes before applying
- Keep secrets out of git (use `.gitignore` for sensitive files)


## Documentation

- [Implementation Plan](docs/IMPLEMENTATION_PLAN.md) - Full roadmap for all planned services
- [Port Mapping](docs/PORTS.md) - Service ports and firewall considerations
