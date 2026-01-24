#!/bin/sh
set -eu

DOMAIN="$(cat /etc/duckdns/domain)"
TOKEN="$(cat /etc/duckdns/token)"

URL="https://duckdns.org/update/${DOMAIN}/${TOKEN}"
curl -fsS "$URL" >/dev/null

echo "DuckDNS daily refresh sent"
