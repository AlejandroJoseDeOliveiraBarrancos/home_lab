# How `make apply` Works

`make apply` is the single command to apply all configurations to the server. It's designed to be idempotent - running it multiple times is safe.

## Flow

1. **Push** - `make apply` depends on `push`, which syncs all files to `~/homelab-config/` on the remote server via rsync (excluding `.git`, `.env`)
2. **Execute apply script** - Runs `scripts/apply-all.sh` on the remote server if it exists, otherwise falls back to inline commands
3. **Apply configs** - Copies files to system locations and restarts services as needed

## Applied Configurations

| Config | Source | Destination | Action |
|---|---|---|---|
| Static IP (Netplan) | `netplan/01-static-ip.yaml` | `/etc/netplan/01-static-ip.yaml` | `sudo netplan apply` |
| Lid-close ignore (logind) | `systemd/logind.conf` | `/etc/systemd/logind.conf` | `sudo systemctl restart systemd-logind` |

## Idempotency

- The script uses `set -e` but allows some commands to fail gracefully with `|| true`
- Copying the same file repeatedly has no harmful effect
- `netplan apply` and `systemctl restart` are safe to run multiple times
- The script checks for file existence before applying

## Usage

```bash
# Apply all configs (pushes first automatically)
make apply

# Just test connectivity
make connect-test

# SSH into server
make ssh

# Check status
make status
```

## Notes

- If applying netplan causes network disconnect, you may need console access to the server
- The apply script runs with sudo for system file modifications
- All changes are tracked in git - commit before applying for audit trail
