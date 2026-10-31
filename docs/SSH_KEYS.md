# SSH Key Setup

Public key is stored in `inventory/server.pub`. Private key should be distributed separately via secure channel.

## Setup

1. Ensure you have the private key (`server` or similar) on your client machine with correct permissions:
```bash
chmod 600 /path/to/private_key
```

2. Copy public key to server and configure authorized_keys:
```bash
make setup-keys
```

Or manually:
```bash
ssh-copy-id -i inventory/server.pub adeoliveira@192.168.1.8
```

## Usage

After key setup, SSH will use key-based auth automatically. The Makefile uses standard SSH which will try keys from ssh-agent or default locations.

If using a non-default key location, add to `~/.ssh/config`:
```
Host homelab
  HostName 192.168.1.8
  User adeoliveira
  IdentityFile ~/.ssh/server
```
Then use `ssh homelab`.
