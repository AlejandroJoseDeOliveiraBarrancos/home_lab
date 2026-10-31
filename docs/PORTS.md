# Ports & Service Mapping

Track all exposed ports for firewall configuration and reverse proxy setup.

## System/Infrastructure
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| SSH | 22 | TCP | LAN/VPN only | Restrict via UFW/Fail2ban |
| Netplan/Networking | - | - | - | No exposed port |

## Reverse Proxy
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| Nginx Proxy Manager HTTP | 80 | TCP | LAN (or internet behind router) | Redirect to HTTPS |
| Nginx Proxy Manager HTTPS | 443 | TCP | LAN (or internet behind router) | Main entry point |
| Traefik Dashboard (if used) | 8080 | TCP | LAN/VPN only | Disable externally |

## Network Services
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| Pi-hole/Admin | 80/443 or 8080 | TCP | LAN/VPN only | Via reverse proxy preferred |
| AdGuardHome | 3000, 80, 443, 53 | TCP/UDP | DNS on 53 | DNS must be reachable on LAN |
| Tailscale | - | UDP | Outbound | Uses WireGuard protocol |
| WireGuard | 51820 | UDP | As needed | If self-hosting WG server |

## Media & Storage
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| Syncthing GUI | 8384 | TCP | LAN/VPN only | Sync protocol uses dynamic ports or configured relay |
| Jellyfin | 8096 | TCP | LAN/VPN only | HTTP, put behind proxy for HTTPS |
| Samba | 445, 139 | TCP | LAN only | File sharing |
| NFS | 2049 | TCP/UDP | LAN only | More strict network ACLs needed |

## Apps & Identity
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| Homepage/Homarr | 3000/7575 | TCP | LAN/VPN only | Dashboard |
| Vaultwarden | 80/443 | TCP | LAN/VPN only | Behind reverse proxy |
| Authelia | 9091 | TCP | LAN/VPN only | SSO portal |
| Gotify | 80/443 | TCP | LAN/VPN only | Notifications API |
| Ntfy | 80/443 | TCP | LAN/VPN only | Notifications API |
| Ollama | 11434 | TCP | LAN/VPN only | API, restrict access |
| Open WebUI | 3000/8080 | TCP | LAN/VPN only | Chat UI |

## Game Servers
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| Minecraft Java | 25565 | TCP | LAN or forwarded as needed | Port forward only if public access required |
| Pterodactyl Panel | 80/443 | TCP | LAN/VPN only | Game panel |
| Pterodactyl Wings | 8080, 2022 | TCP | LAN only | Node communication |

## Security & Monitoring
| Service | Port | Protocol | Internal/External | Notes |
|---|---|---|---|---|
| CrowdSec Dashboard/Console | 8080 | TCP | LAN/VPN only | Metrics/management |
| Step-CA | 9000 | TCP | LAN/VPN only | PKI API |

**Rule:** Only expose 80/443 to internet if absolutely necessary. Prefer VPN (Tailscale) for external access.
