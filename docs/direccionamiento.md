# Direccionamiento — Infraestructura 3 (sufijo 2168)

## Enlaces WAN (/30)

| Enlace | Red | Lado A | Lado B |
| --- | --- | --- | --- |
| ISP ↔ FortiGate | `21.68.3.0/30` | ISP Fa1/0 `.1` | FortiGate port1 `.2` |
| ISP ↔ R-CISCO | `21.68.4.0/30` | ISP Fa1/1 `.1` | R-CISCO Fa1/0 `.2` |

## Redes internas

| Red | Prefijo | Gateway | Uso |
| --- | --- | --- | --- |
| VLAN 10 usuarios | `10.21.68.0/25` | `10.21.68.1` (FortiGate) | PC-USER, DHCP `.10 – .100` |
| LAN servidor | `10.21.68.128/28` | `10.21.68.129` (R-CISCO) | WEB-SV-2168 en `.130` |
| Segmento VPN | `192.168.11.0/24` | — | port3 del FortiGate `.2` y VPN-CLIENT |
| Pool VPN | `10.212.135.10 – .20` | — | IP virtual de los clientes IPsec |

## Interfaces

| Equipo | Interfaz | IP | Nota |
| --- | --- | --- | --- |
| ISP-2168-T2 | Fa0/0 | DHCP | `ip nat outside`, salida a Internet |
| ISP-2168-T2 | Fa1/0 | `21.68.3.1/30` | `ip nat inside`, hacia FortiGate |
| ISP-2168-T2 | Fa1/1 | `21.68.4.1/30` | `ip nat inside`, hacia R-CISCO |
| FortiGate | port1 | `21.68.3.2/30` | WAN-ISP |
| FortiGate | VLAN10-USERS (port2, vlan 10) | `10.21.68.1/25` | gateway de usuarios |
| FortiGate | port3 | `192.168.11.2/24` | VPN y GUI |
| R-CISCO-2168 | Fa1/0 | `21.68.4.2/30` | `ip nat outside` |
| R-CISCO-2168 | Fa1/1 | `10.21.68.129/28` | `ip nat inside` |
| WEB-SV-2168 | ens3 | `10.21.68.130/28` | gw `10.21.68.129` |

## Rutas

| Equipo | Destino | Next hop |
| --- | --- | --- |
| FortiGate | `0.0.0.0/0` | `21.68.3.1` |
| R-CISCO-2168 | `0.0.0.0/0` | `21.68.4.1` |
| ISP-2168-T2 | `10.21.68.128/28` | `21.68.4.2` |

## NAT

| Equipo | Regla |
| --- | --- |
| ISP-2168-T2 | PAT de `21.68.3.0/30` y `21.68.4.0/30` por Fa0/0 (ACL 1) |
| R-CISCO-2168 | PAT de la LAN del servidor por Fa1/0 (ACL 101, excluye destino `21.68.3.2`) |
| R-CISCO-2168 | Estático `tcp 10.21.68.130 443` ↔ `Fa1/0:443` |
| FortiGate | NAT activo en las políticas 1 y 4 |
