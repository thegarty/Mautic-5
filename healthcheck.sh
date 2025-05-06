#!/bin/bash

# Check if Apache is running
if ! pgrep apache2 > /dev/null; then
    echo "Apache is not running"
    exit 1
fi

# Check if the Mautic console file exists and is executable
if [ ! -f /var/www/html/bin/console ]; then
    echo "Mautic console file not found"
    exit 1
fi

# Check if the console file is executable
if [ ! -x /var/www/html/bin/console ]; then
    echo "Mautic console file is not executable"
    exit 1
fi

# Check if we can access the web root
if [ ! -d /var/www/html/public ]; then
    echo "Mautic public directory not found"
    exit 1
fi

# Check if the volume is properly mounted
if ! mount | grep -q "/var/www/html"; then
    echo "Volume not properly mounted"
    exit 1
fi

# Check file permissions
if [ "$(stat -c %U /var/www/html)" != "www-data" ]; then
    echo "Incorrect ownership of /var/www/html"
    exit 1
fi

exit 0 