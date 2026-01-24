#!/bin/sh
set -eu

DOMAIN="$(cat /etc/duckdns/domain)"
TOKEN="$(cat /etc/duckdns/token)"

STATE_DIR="/var/lib/duckdns"
IP_FILE="$STATE_DIR/last_ip"

mkdir -p "$STATE_DIR"

CURRENT_IP="$(curl -4 -fsS https://checkip.amazonaws.com | tr -d '\n')"

LAST_IP=""
[ -f "$IP_FILE" ] && LAST_IP="$(cat "$IP_FILE")"

if [ "$CURRENT_IP" = "$LAST_IP" ]; then
  echo "DuckDNS: IP unchanged ($CURRENT_IP)"
  exit 0
fi

URL="https://duckdns.org/update/${DOMAIN}/${TOKEN}"
RESP="$(curl -fsS "$URL" || true)"

if [ "$RESP" = "KO" ]; then
  echo "DuckDNS update failed"
  exit 1
fi

echo "$CURRENT_IP" > "$IP_FILE"
echo "DuckDNS updated → $CURRENT_IP"
