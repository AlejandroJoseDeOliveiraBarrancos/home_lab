# GitOps Workflow Guide

## Overview

This repository uses a declarative GitOps approach:
1. Define desired state in this Git repo (configs, compose files, scripts)
2. Sync state to server with `make sync` or `make apply`
3. Apply state idempotently on the server

## Directory Structure

- `inventory/` - Host configuration (copy `hosts.example.env` to `hosts.env`)
- `configs/` - System-level config files (netplan, systemd) copied to `/etc/`
- `scripts/` - Orchestration scripts run on server
- `bootstrap/` - One-time server initialization
- `roles/` - Modular configuration roles (future use)
- `stacks/` - Docker Compose stacks organized by purpose

## Workflow

### First Time Setup
```bash
cp inventory/hosts.example.env inventory/hosts.env
# Edit with your server details
make test        # Verify SSH
make bootstrap   # Install docker, packages
make apply       # Apply system configs
```

### Making Changes
```bash
# Edit files locally
git add .
git commit -m "feat: update config"

# Sync and apply
make apply
```

### Key Principles

- **Single source of truth**: All configs live in Git
- **Idempotent**: `make apply` can be run repeatedly safely
- **Declarative**: Define desired end state, scripts enforce it
- **Separation**: System configs in `configs/`, apps in `stacks/`
- **No secrets in Git**: `inventory/hosts.env` is gitignored (use example as template)
