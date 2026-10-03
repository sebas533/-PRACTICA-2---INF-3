#!/usr/bin/env bash
# PC-USER-2168: pruebas sin VPN
WEB_PUB="21.68.4.2"      # IP publica del router (NAT 443)
WEB_LAN="10.21.68.130"   # servidor
GW="10.21.68.1"          # FortiGate VLAN 10
SSH_USER="${1:-usuario}"

ok()   { echo "[OK]   $1"; }
fail() { echo "[FAIL] $1"; }

echo "== 1. DHCP en VLAN 10 =="
IP=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1)
echo "IP: $IP"
case "$IP" in 10.21.68.*) ok "IP dentro de 10.21.68.0/25";; *) fail "IP fuera de rango";; esac

echo "== 2. Gateway =="
ping -c 3 -W 2 $GW >/dev/null && ok "ping a $GW" || fail "ping a $GW"

echo "== 3. HTTPS sin VPN =="
CODE=$(curl -k -s -o /dev/null -w "%{http_code}" --max-time 8 https://$WEB_PUB)
[ "$CODE" = "200" ] && ok "https://$WEB_PUB responde 200" || fail "https://$WEB_PUB devolvio '$CODE'"
curl -k -I --max-time 8 https://$WEB_PUB 2>/dev/null | head -n 3

echo "== 4. SSH directo (debe fallar) =="
if ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=no $SSH_USER@$WEB_LAN true 2>/dev/null; then
  fail "el SSH directo NO esta bloqueado"
else
  ok "SSH directo bloqueado"
fi
