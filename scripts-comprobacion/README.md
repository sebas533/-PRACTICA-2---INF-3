# scripts

Scripts y comandos de apoyo para preparar el servidor y repetir las pruebas de la práctica.

| Archivo | Dónde se ejecuta | Para qué |
| --- | --- | --- |
| `web-server-services-setup.sh` | WEB-SV-2168 | Instala Apache2 con HTTPS (certificado autofirmado) y OpenSSH |
| `test-pc-user.sh` | PC-USER-2168 | DHCP, gateway, HTTPS sin VPN y SSH directo bloqueado |
| `test-vpn-client.sh` | VPN-CLIENT-2168 | Levanta la VPN, comprueba IP virtual, ruta y SSH, y la baja al final |
| `switch-setup.txt` | Switch | VLAN 10, trunk hacia el FortiGate y puerto de acceso |
| `r-cisco-critical-config.txt` | R-CISCO-2168 | NAT estático del 443, PAT y exención de la VPN |

Los `.sh` se ejecutan con `bash script.sh` (algunos piden `sudo`).
