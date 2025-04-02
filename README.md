# BIND DNS Server Configuration

This repository contains the configuration files for a BIND DNS server based on the host file from a MacOS system. The configuration is designed to be transferred to an Ubuntu BIND server.

## Directory Structure

- `named.conf` - Main BIND configuration file
- `named.conf.local` - Local zone configurations
- `zones/` - Directory containing all zone files
  - Forward zones: `db.vgriz.com`, `db.regulogix.com`, `db.familycabin.io`
  - Reverse zones: `db.10.1`, `db.10.16.1`, `db.172.18.1`, `db.172.18.5`, `db.172.18.232`, `db.192.168.4`
- `update_bind.sh` - Script to pull updates from this repository

## Setup Instructions

1. Install BIND on your Ubuntu server:
   ```
   sudo apt update
   sudo apt install bind9 bind9utils bind9-doc
   ```

2. Clone this repository:
   ```
   git clone https://github.com/FlunkyMonkey/bind.git
   ```

3. Run the update script to deploy the configuration:
   ```
   sudo ./update_bind.sh
   ```

4. Verify the BIND service is running:
   ```
   sudo systemctl status bind9
   ```

## Automatic Updates

To automatically update your BIND configuration from this repository, you can set up a cron job:

```
sudo crontab -e
```

Add the following line to run the update script daily at 2 AM:

```
0 2 * * * /path/to/update_bind.sh
```

## Zone Information

The configuration includes the following domains:
- vgriz.com (primary domain)
- regulogix.com
- familycabin.io

And the following network segments:
- IOT Network (10.1.x.x)
- VLAN 16 DMZ Network (10.16.1.x)
- Management Network (172.18.1.x)
- Secondary VM Network (172.18.5.x)
- VM Network (172.18.232.x)
- Home Network (192.168.4.x)

## Troubleshooting

- Check BIND configuration syntax:
  ```
  sudo named-checkconf
  ```

- Check zone file syntax:
  ```
  sudo named-checkzone vgriz.com /etc/bind/zones/db.vgriz.com
  ```

- View BIND logs:
  ```
  sudo journalctl -u bind9
  ```
