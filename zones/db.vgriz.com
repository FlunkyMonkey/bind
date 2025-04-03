; BIND zone file for vgriz.com
; Created on: 2025-04-01

$TTL    604800      ; 1 week default TTL
@       IN      SOA     DNS1.vgriz.com. admin.vgriz.com. (
                        2025040101      ; Serial (YYYYMMDDNN)
                        604800          ; Refresh (1 week)
                        86400           ; Retry (1 day)
                        2419200         ; Expire (4 weeks)
                        604800 )        ; Negative Cache TTL (1 week)

; Name servers
@       IN      NS      DNS1.vgriz.com.
@       IN      NS      DNS2.vgriz.com.

; Mail exchanger
@       IN      MX      10      web.vgriz.com.

; A records sorted by IP
; IOT Network (10.1.x.x)
pi                  IN      A       10.1.0.2

; VLAN 16 DMZ Network (10.16.1.x)
gateway-dmz-10-16-1-x    IN      A       10.16.1.1
@                   IN      A       10.16.1.5
web                 IN      A       10.16.1.15
www                 IN      A       10.16.1.15
arma                IN      A       10.16.1.20

; Unused Networks
VLAN102-unused      IN      A       10.20.20.1
VLAN103-unused      IN      A       10.30.30.1
VLAN101-unused      IN      A       10.40.40.1

; Management Network (172.18.1.x)
gateway-management-172-18-1-x  IN      A       172.18.1.1
firewalla           IN      A       172.18.1.1
sunwap              IN      A       172.18.1.3
denwap              IN      A       172.18.1.4
basementwap         IN      A       172.18.1.5
rancherwap          IN      A       172.18.1.6
unifiswitch         IN      A       172.18.1.7
prox1               IN      A       172.18.1.10
mbipmi01mgmt        IN      A       172.18.1.11
unifi               IN      A       172.18.1.12
mikrotik            IN      A       172.18.1.13
prox2               IN      A       172.18.1.20
sdr                 IN      A       172.18.1.28
prox3               IN      A       172.18.1.30
peakups             IN      A       172.18.1.38
peakupsmgmt         IN      A       172.18.1.38
peakups02           IN      A       172.18.1.39
peakups02mgmt       IN      A       172.18.1.39
prox4               IN      A       172.18.1.40
prox5               IN      A       172.18.1.50
TrueNAS01           IN      A       172.18.1.96
TrueNAS02           IN      A       172.18.1.97

; Secondary VM Network (172.18.5.x)
gateway-vmdata-alternate-172-18-5-x  IN      A       172.18.5.1
DNS2                IN      A       172.18.5.10
ntp                 IN      A       172.18.5.10

; VM Network (172.18.232.x)
gateway-vmdata-172-18-232-x  IN      A       172.18.232.1
DNS1                IN      A       172.18.232.10
ntp                 IN      A       172.18.232.10
rmm                 IN      A       172.18.232.50
minecraft           IN      A       172.18.232.240
netdata             IN      A       172.18.232.245
unifi               IN      A       172.18.232.251

; Home Network (192.168.4.x)
gateway-wlan-192-168-4-x  IN      A       192.168.4.1
@                   IN      A       192.168.4.1

; Additional domains
regulogix           IN      CNAME   web
www.regulogix       IN      CNAME   web
familycabin.io.     IN      CNAME   web
