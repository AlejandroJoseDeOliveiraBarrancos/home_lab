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
