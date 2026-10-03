#!/usr/bin/env bash
# VPN-CLIENT-2168: prueba completa de la VPN (ejecutar con sudo)
CONN="VPN-REMOTE-2168"
WEB_LAN="10.21.68.130"
SSH_USER="${1:-usuario}"

ok()   { echo "[OK]   $1"; }
fail() { echo "[FAIL] $1"; }

echo "== 1. SSH antes de la VPN (debe fallar) =="
ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=no $SSH_USER@$WEB_LAN true 2>/dev/null \
  && fail "hay acceso SSH sin VPN" || ok "sin VPN no hay SSH"

echo "== 2. Levantar tunel =="
ipsec up $CONN
sleep 3
ipsec status | grep -q "ESTABLISHED\|INSTALLED" && ok "tunel establecido" || fail "tunel no establecido"

echo "== 3. IP virtual =="
ip -4 addr | grep "10.212.135" && ok "IP virtual del pool" || fail "sin IP virtual"

echo "== 4. Ruta hacia el servidor =="
ip route get $WEB_LAN
ip route show table 220 2>/dev/null

echo "== 5. Puerto 22 y SSH =="
nc -zv -w 5 $WEB_LAN 22 && ok "puerto 22 abierto por la VPN" || fail "puerto 22 cerrado"
ssh -o ConnectTimeout=8 -o StrictHostKeyChecking=no $SSH_USER@$WEB_LAN "hostname; whoami"

echo "== 6. Bajar tunel =="
ipsec down $CONN
sleep 2
ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=no $SSH_USER@$WEB_LAN true 2>/dev/null \
  && fail "sigue habiendo SSH con la VPN abajo" || ok "con la VPN abajo no hay SSH"
