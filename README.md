# DuckDNS LXC Updater (Proxmox)

Minimal, reliable DuckDNS updater designed for Proxmox LXC containers.

## Features

- Updates DuckDNS **only when public IP changes**
- Uses `https://checkip.amazonaws.com` to detect public IPv4
- Daily safety refresh (once per day)
- systemd-based (no cron)
- Very low resource usage
- Suitable for 24/7 servers

## Requirements

- Proxmox LXC (Debian 12 or Ubuntu recommended)
- systemd
- curl

## Installation

```bash
git clone https://github.com/puhi0210/duckdns-updater-lxc.git
cd duckdns-updater-lxc
chmod +x install.sh
sudo ./install.sh
```
## Configuration

During installation, you will be prompted for:

- **DuckDNS domain** (without `.duckdns.org`)
- **DuckDNS token**

---

## How it works

### Every 10 minutes
- Check current public IPv4 address
- Update DuckDNS **only if the IP has changed**

### Once per day
- Force a refresh to prevent stale DNS records

---

## Systemd timers

To verify active timers:

```bash
systemctl list-timers | grep duckdns
```
## Logs
```bash
journalctl -u duckdns.service
journalctl -u duckdns-force.service
```
## Security notes

- Token stored in /etc/duckdns/token (chmod 600)
- No hardcoded secrets
- No external dependencies beyond curl
