# Phases 2 & 3 Guide

## Phase 2: Containerization & Reverse Proxy

1. Install Docker: `make docker` (log out/in or `newgrp docker` after)
2. Start Nginx Proxy Manager: `make npm-up`
3. Access admin UI: `http://<SERVER_IP>:81`
   - Default login: `admin@example.com` / `changeme` (change immediately)

## Phase 3: Network Security & Ad-Blocking

1. Configure firewall: `make firewall`
2. Start AdGuardHome: `make adguard-up` (creates `proxy` network on first npm-up)
3. Initial setup: `http://<SERVER_IP>:3000`
4. Install Tailscale: `make tailscale-up` (follow auth URL)
5. Point DNS clients to server IP or set on router

## Notes
- Keep :81, :3000 on LAN/VPN only
- Put services behind NPM on the `proxy` network
- All configs tracked in Git
