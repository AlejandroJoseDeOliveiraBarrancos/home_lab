# Fail2ban Setup

Protect SSH and services from brute force attacks.

## Usage
Run on the host:
```bash
sudo apt install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# Edit jail.local for SSH
sudo systemctl enable --now fail2ban
```

## Notes
- Monitor with `sudo fail2ban-client status sshd`
- Integrates well with UFW
