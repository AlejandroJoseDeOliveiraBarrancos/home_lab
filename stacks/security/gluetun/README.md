# Gluetun VPN Client

Gluetun routes traffic from specific containers through a VPN provider. Useful for privacy or bypassing geo-restrictions.

## Usage
1. Copy `.env.example` to `.env` and fill provider details
2. `docker compose up -d`
3. Add other containers to use `network_mode: "service:gluetun"`

## Notes
- Only route containers that need it
- Keep DNS through AdGuardHome or VPN provider as configured
- Monitor for leaks
