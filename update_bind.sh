#!/bin/bash
# Script to update BIND configuration from GitHub repository
# Created on: 2025-04-01

# Configuration
REPO_URL="https://github.com/FlunkyMonkey/bind.git"
REPO_DIR="/tmp/bind_repo"
BIND_CONFIG_DIR="/etc/bind"
LOG_FILE="/var/log/bind_update.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Create log file if it doesn't exist
touch "$LOG_FILE"

log_message "Starting BIND configuration update"

# Check if git is installed
if ! command -v git &> /dev/null; then
    log_message "ERROR: Git is not installed. Please install git."
    exit 1
fi

# Remove previous repo directory if it exists
if [ -d "$REPO_DIR" ]; then
    log_message "Removing previous repository directory"
    rm -rf "$REPO_DIR"
fi

# Clone the repository
log_message "Cloning repository from $REPO_URL"
git clone "$REPO_URL" "$REPO_DIR"

if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to clone repository"
    exit 1
fi

# Backup current configuration
BACKUP_DIR="$BIND_CONFIG_DIR/backup_$(date '+%Y%m%d%H%M%S')"
log_message "Creating backup of current configuration to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r "$BIND_CONFIG_DIR/named.conf" "$BIND_CONFIG_DIR/named.conf.local" "$BIND_CONFIG_DIR/zones" "$BACKUP_DIR/" 2>/dev/null

# Copy configuration files
log_message "Copying configuration files to $BIND_CONFIG_DIR"
cp "$REPO_DIR/named.conf" "$BIND_CONFIG_DIR/" 2>/dev/null
cp "$REPO_DIR/named.conf.local" "$BIND_CONFIG_DIR/" 2>/dev/null

# Create zones directory if it doesn't exist
mkdir -p "$BIND_CONFIG_DIR/zones"

# Copy zone files
log_message "Copying zone files to $BIND_CONFIG_DIR/zones"
cp "$REPO_DIR/zones/"* "$BIND_CONFIG_DIR/zones/" 2>/dev/null

# Set proper permissions
log_message "Setting proper permissions"
chown -R bind:bind "$BIND_CONFIG_DIR"
chmod -R 644 "$BIND_CONFIG_DIR"
chmod 755 "$BIND_CONFIG_DIR" "$BIND_CONFIG_DIR/zones"

# Check configuration syntax
log_message "Checking BIND configuration syntax"
named-checkconf

if [ $? -ne 0 ]; then
    log_message "ERROR: Configuration syntax check failed. Restoring backup."
    cp -r "$BACKUP_DIR/"* "$BIND_CONFIG_DIR/"
    exit 1
fi

# Check zone files syntax
for zone_file in "$BIND_CONFIG_DIR/zones/db."*; do
    zone_name=$(basename "$zone_file" | sed 's/^db\.//')
    log_message "Checking zone file syntax for $zone_name"
    named-checkzone "$zone_name" "$zone_file"
    
    if [ $? -ne 0 ]; then
        log_message "ERROR: Zone file syntax check failed for $zone_name. Restoring backup."
        cp -r "$BACKUP_DIR/"* "$BIND_CONFIG_DIR/"
        exit 1
    fi
done

# Restart BIND service
log_message "Restarting BIND service"
systemctl restart bind9

if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to restart BIND service. Restoring backup."
    cp -r "$BACKUP_DIR/"* "$BIND_CONFIG_DIR/"
    systemctl restart bind9
    exit 1
fi

log_message "BIND configuration update completed successfully"

# Clean up
log_message "Cleaning up temporary files"
rm -rf "$REPO_DIR"

exit 0
