# Roadmap for Phases 3-7

This document tracks all upcoming services with their stack structure and implementation notes.

## Phase 3: Network Security & Ad-Blocking
| Service | Stack Path | Status | Notes |
|---|---|---|---|
| AdGuardHome | `stacks/core/adguardhome/` | Done | DNS sinkhole running |
| Unbound/Cloudflared (DoH) | `stacks/security/cloudflared/` | Planned | Encrypted upstream DNS |
| Tailscale/WireGuard | Host/Container | Done | Tailscale installed |
| CrowdSec | `stacks/security/crowdsec/` | Planned | Log analysis + IP blocking |
| Gluetun | `stacks/security/gluetun/` | Planned | VPN client for selective containers |

## Phase 4: Media, Storage & Sync
| Service | Stack Path | Status | Notes |
|---|---|---|---|
| Syncthing | `stacks/media/syncthing/` | Planned | P2P sync |
| Samba/NFS/FileBrowser | `stacks/storage/filebrowser/` | Planned | Network file sharing |
| Jellyfin/Emby/Plex | `stacks/media/jellyfin/` | Planned | Media streaming |
| Duplicati/Kopia | `stacks/storage/duplicati/` | Planned | Automated backups |

## Phase 5: Self-Hosted Apps & Identity
| Service | Stack Path | Status | Notes |
|---|---|---|---|
| Homepage/Homarr | `stacks/apps/homepage/` | Planned | Dashboard |
| Vaultwarden | `stacks/apps/vaultwarden/` | Planned | Bitwarden alternative |
| Authelia | `stacks/apps/authelia/` | Planned | SSO/2FA |
| Gotify/Ntfy | `stacks/apps/ntfy/` | Planned | Notifications |
| Ollama + Open WebUI | `stacks/apps/ollama-openwebui/` | Planned | Local LLMs |

## Phase 6: Game Servers & Management
| Service | Stack Path | Status | Notes |
|---|---|---|---|
| Minecraft | `stacks/games/minecraft/` | Planned | Vanilla/modded |
| Pterodactyl | `stacks/games/pterodactyl/` | Planned | Panel + Wings |
| LinuxGSM | `stacks/games/linuxgsm/` | Planned | Lightweight manager |
| Game Backups | `stacks/storage/kopia/` | Planned | World backups |

## Phase 7: PKI & Advanced Security
| Service | Stack Path | Status | Notes |
|---|---|---|---|
| Step-CA | `stacks/infra/step-ca/` | Planned | Internal CA |
| Fail2ban | Host service | Planned | Brute force protection |
| UFW hardening | Host | Done | Base rules in place |
