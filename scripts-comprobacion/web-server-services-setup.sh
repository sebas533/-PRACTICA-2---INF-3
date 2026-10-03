#!/usr/bin/env bash
# WEB-SV-2168: Apache2 con HTTPS y OpenSSH
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Ejecutar con sudo"; exit 1
fi

apt update
apt install -y apache2 openssh-server openssl

# Certificado autofirmado
mkdir -p /etc/ssl/practica
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -subj "/C=DO/O=Practica2/CN=WEB-SV-2168" \
  -keyout /etc/ssl/practica/web.key \
  -out /etc/ssl/practica/web.crt

a2enmod ssl
sed -i 's#SSLCertificateFile.*#SSLCertificateFile /etc/ssl/practica/web.crt#' /etc/apache2/sites-available/default-ssl.conf
sed -i 's#SSLCertificateKeyFile.*#SSLCertificateKeyFile /etc/ssl/practica/web.key#' /etc/apache2/sites-available/default-ssl.conf
a2ensite default-ssl

echo "<h1>WEB-SV-2168 - Practica 2 Infraestructura 3</h1>" > /var/www/html/index.html

systemctl enable --now apache2 ssh
systemctl restart apache2

echo
echo "Puertos en escucha:"
ss -tlnp | grep -E ':(22|443)\s'
