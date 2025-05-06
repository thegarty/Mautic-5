#!/bin/bash
set -e

# Function to initialize a directory
init_directory() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
    
    # Set proper permissions
    chown -R www-data:www-data "$dir"
    chmod -R 775 "$dir"
}

# Initialize persistent directories
echo "Initializing persistent directories..."
init_directory "/var/www/html/app/config"
init_directory "/var/www/html/media"
init_directory "/var/www/html/var/logs"
init_directory "/var/www/html/var/cache"
init_directory "/var/www/html/var/spool"
init_directory "/var/www/html/var/tmp"

# Ensure proper permissions on the entire Mautic installation
echo "Setting permissions on Mautic installation..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 775 {} \;
find /var/www/html -type f -exec chmod 664 {} \;

# Make sure the console is executable
if [ -f /var/www/html/bin/console ]; then
    chmod +x /var/www/html/bin/console
fi

# Run debug script to verify setup
echo "Running debug script to verify setup..."
/usr/local/bin/debug.sh

# Execute the main command
echo "Starting Apache..."
exec "$@" 