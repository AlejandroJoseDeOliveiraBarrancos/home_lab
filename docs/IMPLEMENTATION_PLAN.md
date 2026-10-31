# Homelab Implementation Plan

This document outlines the full roadmap for repurposing an old Ubuntu laptop into a comprehensive homelab server. All configurations will be tracked in this Git repository for reproducibility.

## Current State (Phase 0)
- [x] Git-backed configuration repo set up
- [x] Netplan static IP configuration
- [x] systemd-logind lid-close prevention
- [x] Makefile for automation (push, apply-ip, apply-lid, ssh)
- [x] Basic documentation

## Phase 1: Core Server Setup (In Progress)
Goal: Establish reliable remote access with static networking.

| Task | Status | Notes |
|---|---|---|
| Configure static IP via Netplan | Ready | `make apply-ip` |
| Prevent lid suspension | Ready | `make apply-lid` |
| SSH access from client | Ready | `make ssh` |
| Update `.env` for actual network values | Pending | Run `ip a` on server to confirm interface |
| Test connectivity on static IP | Pending | After applying netplan |

**Verification:** `make status` shows correct IP/interface, SSH works after applying static IP.

## Phase 2: Containerization & Reverse Proxy
Goal: Deploy Docker and a reverse proxy for service routing.

| Service | Priority | Purpose | Implementation |
|---|---|---|---|
| Docker & Docker Compose | P0 | Container runtime | Install via official script, add user to docker group |
| Nginx Proxy Manager OR Traefik OR Caddy | P0 | Automated reverse proxy with SSL | Start with NPM (GUI) or Traefik (config-as-code) |
| Watchtower (optional) | P2 | Auto-update containers | For non-critical services |

**Target:** All web services accessible via `*.home.local` or custom domain with HTTPS.

## Phase 3: Network Security & Ad-Blocking
Goal: Network-wide protection and DNS control.

| Service | Priority | Purpose | Implementation |
|---|---|---|---|
| Pi-hole OR AdGuardHome | P0 | Network-wide ad blocking | DNS sinkhole, local DNS records |
| Unbound/NextDNS upstream OR Cloudflared | P1 | Encrypted DNS | DoH/DoT for upstream resolution |
| Tailscale OR WireGuard | P0 | Secure remote access | Mesh VPN for access outside LAN |
| CrowdSec | P1 | Intrusion prevention | Parse logs, block malicious IPs |
| Gluetun | P1 | VPN client for containers | Route specific containers through VPN |

## Phase 4: Media, Storage & Sync
Goal: Centralized storage and media access.

| Service | Priority | Purpose | Implementation |
|---|---|---|---|
| Syncthing | P0 | Cross-device continuous file sync | Peer-to-peer encrypted sync |
| File browser/Samba/NFS | P1 | Network file sharing | SMB for Windows/Mac, NFS for Linux |
| Jellyfin/Emby/Plex | P1 | Media server | Stream movies/TV/music |
| Duplicati/Kopia | P0 | Automated backups | Backup critical volumes to local/external storage |

## Phase 5: Self-Hosted Apps & Identity
Goal: Productivity, authentication, and notifications.

| Service | Priority | Purpose | Implementation |
|---|---|---|---|
| Homepage OR Homarr | P0 | Unified dashboard | Service links, status widgets |
| Vaultwarden | P0 | Bitwarden-compatible password manager | Self-hosted, with admin panel |
| Authelia | P2 | SSO/2FA for services | Protect internal services |
| Gotify OR Ntfy | P1 | Self-hosted push notifications | Alerting from services/scripts |
| Ollama + Open WebUI | P1 | Local LLM inference | Run models locally, web interface |

## Phase 6: Game Servers & Management
Goal: Host multiplayer game servers with management tools.

| Service | Priority | Purpose | Implementation |
|---|---|---|---|
| Minecraft Server (Vanilla/Modded) | P1 | Minecraft hosting | Direct or via panel |
| Pterodactyl Panel + Wings | P2 | Multi-game server management | Web UI for game servers |
| LinuxGSM | P2 | Lightweight game server manager | Script-based alternative to Pterodactyl |
| Game Server Backups | P0 | Automated backups | Kopia/Duplicati for server worlds/data |

## Phase 7: PKI & Advanced Security
Goal: Internal certificate authority and advanced hardening.

| Service | Priority | Purpose | Implementation |
|---|---|---|---|
| Step-CA | P2 | Local Certificate Authority | Issue internal TLS certs |
| Fail2ban (baseline) | P1 | Brute-force protection | SSH and service protection |
| UFW/iptables hardening | P0 | Firewall rules | Default deny, allow necessary ports |

## Implementation Strategy

### Directory Structure Expansion
As services are added, extend the repo structure:

```text
homelab-config/
├── .env
├── Makefile
├── docker/           # docker-compose files per service/stack
├── scripts/          # provisioning/maintenance scripts
├── systemd/          # systemd units
├── netplan/          # network config
├── nginx/            # reverse proxy configs (if not using NPM)
├── traefik/          # traefik dynamic/static config
├── docs/             # documentation (this file)
└── ansible/          # (optional) future IaC expansion
```

### Git Workflow
1. Make changes in local repo
2. Test/configure locally first when possible
3. Commit with conventional commits (`feat:`, `fix:`, `docs:`, `chore:`)
4. Push to server via `make push`
5. Apply changes via targeted make commands or docker compose
6. Document in `docs/` and update README

### Security Principles
- Never commit secrets - use `.env` files (gitignored) with `.env.example` templates
- Use VPN/Tailscale for external access, avoid exposing everything to internet
- Run containers as non-root where possible
- Keep system packages updated
- Use CrowdSec + Fail2ban for threat detection
- Implement proper backup strategy before critical data

### First Actions (Immediate)
1. **Update network config**: Edit `.env` with correct `SERVER_INTERFACE`, confirm IP/Gateway/DNS
2. **Verify server access**: Ensure SSH key auth works to server
3. **Apply base config**: `make push && make apply-ip && make apply-lid`
4. **Install Docker**: Create `scripts/install-docker.sh` and apply
5. **Deploy reverse proxy**: Start with Nginx Proxy Manager via docker-compose
6. **Set up dashboard**: Deploy Homepage/Homarr

## Notes & Considerations
- Old laptop has limited resources - monitor CPU/RAM/disk usage
- SSD/HDD health matters for long-running services
- Consider power management beyond lid-close (suspend, wake-on-lan)
- Plan IP allocation (static IPs for server, DHCP reservations for others)
- Document port mappings in `docs/ports.md` as services grow
