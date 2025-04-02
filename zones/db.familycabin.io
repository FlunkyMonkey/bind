; BIND zone file for familycabin.io
; Created on: 2025-04-01

$TTL    86400
@       IN      SOA     DNS1.vgriz.com. admin.familycabin.io. (
                        2025040101      ; Serial (YYYYMMDDNN)
                        3600            ; Refresh (1 hour)
                        1800            ; Retry (30 minutes)
                        604800          ; Expire (1 week)
                        86400 )         ; Minimum TTL (24 hours)

; Name servers
@       IN      NS      DNS1.vgriz.com.
@       IN      NS      DNS2.vgriz.com.

; Mail exchanger
@       IN      MX      10      web.vgriz.com.

; Primary domain addresses
@       IN      A       10.16.1.15
www     IN      A       10.16.1.15
