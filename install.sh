#!/bin/sh
set -eu

echo "== DuckDNS LXC installer =="

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

apt update
apt install -y curl ca-certificates

mkdir -p /etc/duckdns
chmod 700 /etc/duckdns

if [ ! -f /etc/duckdns/domain ]; then
  echo "Enter DuckDNS domain (without .duckdns.org):"
  read DOMAIN
  echo "$DOMAIN" > /etc/duckdns/domain
fi

if [ ! -f /etc/duckdns/token ]; then
  echo "Enter DuckDNS token:"
  read TOKEN
  echo "$TOKEN" > /etc/duckdns/token
fi

chmod 600 /etc/duckdns/domain /etc/duckdns/token

install -m 755 scripts/duckdns-update.sh /usr/local/bin/
install -m 755 scripts/duckdns-force-update.sh /usr/local/bin/

install -m 644 systemd/*.service /etc/systemd/system/
install -m 644 systemd/*.timer /etc/systemd/system/

systemctl daemon-reload
systemctl enable --now duckdns.timer duckdns-force.timer

echo "DuckDNS updater installed and running."
systemctl list-timers | grep duckdns
