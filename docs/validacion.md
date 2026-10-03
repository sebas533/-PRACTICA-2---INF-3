# Matriz de validación

| # | Prueba | Desde | Comando | Resultado esperado |
| --- | --- | --- | --- | --- |
| 1 | DHCP en VLAN 10 | PC-USER-2168 | `ip -4 a` | IP dentro de `10.21.68.10 – .100` |
| 2 | Gateway de usuarios | PC-USER-2168 | `ping -c3 10.21.68.1` | Responde |
| 3 | Ruta del ISP hacia el servidor | ISP-2168-T2 | `show ip route 10.21.68.130` | `10.21.68.128/28` vía `21.68.4.2` (estática) |
| 4 | NAT estático HTTPS | R-CISCO-2168 | `show ip nat translations` | Entrada `tcp 21.68.4.2:443 ↔ 10.21.68.130:443` |
| 5 | HTTPS sin VPN | PC-USER-2168 | `curl -k -I https://21.68.4.2` | `HTTP/1.1 200 OK` |
| 6 | SSH directo | PC-USER-2168 | `ssh -o ConnectTimeout=5 usuario@10.21.68.130` | `Connection timed out` |
| 7 | Túnel IPsec | VPN-CLIENT-2168 | `sudo ipsec up VPN-REMOTE-2168` | `connection ... established` |
| 8 | IP virtual y ruta | VPN-CLIENT-2168 | `ip a`, `ip route get 10.21.68.130` | IP `10.212.135.x`, ruta por la VPN |
| 9 | SSH por VPN | VPN-CLIENT-2168 | `ssh usuario@10.21.68.130` | Sesión abierta |
| 10 | VPN abajo | VPN-CLIENT-2168 | `sudo ipsec down VPN-REMOTE-2168` y `ssh ...` | Sin acceso |

Los scripts `test-pc-user.sh` y `test-vpn-client.sh` repiten las pruebas 1, 2, 5, 6 y 7 – 10.
