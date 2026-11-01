# Homelab GitOps Repository

Git-backed configuration management for homelab infrastructure. Declarative, idempotent, and version-controlled.

## Architecture

This repo follows a GitOps-style structure:

```
.
├── bootstrap/     # Initial setup scripts for fresh server
├── configs/       # System configuration files (copied to remote)
├── inventory/     # Host inventory and environment variables
├── roles/         # Reusable configuration roles
├── scripts/       # Orchestration scripts
├── stacks/        # Docker Compose stacks for services
└── docs/          # Documentation
```

## Quick Start

1. Configure inventory: `cp inventory/hosts.example.env inventory/hosts.env && edit inventory/hosts.env`
2. Bootstrap server (first time): `make bootstrap`
3. Sync and apply configs: `make apply`
4. SSH to server: `make ssh`

## Commands

- `make bootstrap` - Initial server setup (install packages, docker, etc.)
- `make sync` - Sync configs to server without applying
- `make apply` - Sync and apply all configurations (idempotent)
- `make ssh` - SSH into server
- `make status` - Check server status
- `make test` - Test connectivity

- [SSH Keys](docs/SSH_KEYS.md) - Key setup and distribution

- [Phases 2 & 3](docs/PHASES_2_3.md) - Docker, Nginx Proxy Manager, AdGuardHome, UFW, Tailscale
- [Current State](docs/CURRENT_STATE.md) - Snapshot of working configuration

## Access URLs

| Service | URL | Notes |
| --- | --- | --- |
| Nginx Proxy Manager (Admin) | http://192.168.1.8:81 | Reverse proxy management |
| AdGuardHome (via NPM) | http://adguard.home.local | DNS filtering dashboard (add to hosts file) |
| AdGuardHome (direct DNS) | 192.168.1.8:53 | Use as DNS server on devices |
| Tailscale | https://login.tailscale.com | Remote access (after auth) |

## Roadmap
- [Phases 3-7 Roadmap](docs/roadmap/PHASES_3_7.md) - All planned services with templates

## All Service Access URLs

| Service | Local URL | Via NPM (recommended) | Notes |
| --- | --- | --- | --- |
| Nginx Proxy Manager | http://192.168.1.8:81 | - | Admin panel for reverse proxy |
| AdGuardHome | http://adguard.home.local | http://adguard.home.local | DNS filtering (add to hosts: 192.168.1.8 adguard.home.local) |
| Vaultwarden | http://192.168.1.8:8080 | http://vault.home.local | Bitwarden-compatible password manager |
| ntfy | http://192.168.1.8:8081 | http://ntfy.home.local | Push notifications |
| Jellyfin | http://192.168.1.8:8096 | http://jellyfin.home.local | Media streaming |
| Syncthing | http://192.168.1.8:8384 | http://sync.home.local | File sync (pair devices) |
| Homepage | http://192.168.1.8:3001 | http://home.home.local | Dashboard |
| OpenWebUI | http://192.168.1.8:3002 | http://ai.home.local | Chat UI for Ollama |
| Ollama API | http://192.168.1.8:11434 | - | API endpoint |
| Duplicati | http://192.168.1.8:8200 | http://backup.home.local | Backups |
| Minecraft | 192.168.1.8:25565 | - | Java Edition server |
| CrowdSec | Internal only | - | IPS, check logs via docker |
| Gluetun | Internal/VPN routing | - | Configure VPN in .env |

## Quick Commands

```bash
make test        # Test SSH connectivity
make status      # Check server & containers
make stats       # Battery/CPU/RAM/disk/temps
make up          # Start all services
make down        # Stop all services
make docker      # Install Docker
make firewall    # Configure UFW
make tailscale-up # Setup Tailscale
make fail2ban-up # Install Fail2ban
make apply       # Apply all system configs
```

## Notes
- Add entries to Windows hosts file (`C:\Windows\System32\drivers\etc\hosts`) for `*.home.local` domains pointing to `192.168.1.8`
- Gluetun needs VPN credentials in `stacks/security/gluetun/.env`
- Jellyfin/Syncthing permissions fixed automatically
- Use AdGuardHome as DNS (192.168.1.8) for network-wide blocking
