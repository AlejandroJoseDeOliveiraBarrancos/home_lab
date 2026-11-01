# CrowdSec

Intrusion prevention system that analyzes logs and blocks malicious IPs.

## Usage
1. Configure log sources in `config/`
2. `docker compose up -d`
3. Install bouncer if needed (e.g., firewall bouncer)

## Notes
- Needs access to logs (NPM, SSH, etc.)
- Can integrate with UFW/iptables
