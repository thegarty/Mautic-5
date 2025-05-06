#!/bin/bash
set -e

echo "Starting health check..."

# Check if Apache is running
if ! pgrep apache2 > /dev/null; then
    echo "Apache is not running"
    exit 1
fi

# Check if the Mautic console file exists
if [ ! -f /var/www/html/bin/console ]; then
    echo "Mautic console file not found"
    ls -la /var/www/html/bin/
    exit 1
fi

# Check if the console file is executable
if [ ! -x /var/www/html/bin/console ]; then
    echo "Mautic console file is not executable"
    ls -la /var/www/html/bin/console
    exit 1
fi

# Check if we can access the web root
if [ ! -d /var/www/html/public ]; then
    echo "Mautic public directory not found"
    ls -la /var/www/html/
    exit 1
fi

# Check if the volume is properly mounted
if ! mount | grep -q "/var/www/html"; then
    echo "Volume not properly mounted"
    mount | grep -E "bind|volume"
    exit 1
fi

# Check file permissions
if [ "$(stat -c %U /var/www/html)" != "www-data" ]; then
    echo "Incorrect ownership of /var/www/html"
    ls -la /var/www/html
    exit 1
fi

# Check if logs directory exists and is writable
if [ ! -d /var/www/html/var/logs ]; then
    echo "Logs directory not found"
    mkdir -p /var/www/html/var/logs
    chown www-data:www-data /var/www/html/var/logs
    chmod 775 /var/www/html/var/logs
fi

# Check Apache error log
if [ -f /var/log/apache2/error.log ]; then
    echo "Last 5 lines of Apache error log:"
    tail -n 5 /var/log/apache2/error.log
fi

# Check PHP error log
if [ -f /var/www/html/var/logs/php_errors.log ]; then
    echo "Last 5 lines of PHP error log:"
    tail -n 5 /var/www/html/var/logs/php_errors.log
fi

# Create a simple health check file
echo "<?php echo 'OK'; ?>" > /var/www/html/public/s/health
chown www-data:www-data /var/www/html/public/s/health
chmod 644 /var/www/html/public/s/health

echo "Health check passed"
exit 0 