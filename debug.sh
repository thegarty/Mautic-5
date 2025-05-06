#!/bin/bash

echo "=== System Information ==="
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

echo -e "\n=== Apache Status ==="
apache2ctl -S
apache2ctl -M

echo -e "\n=== PHP Information ==="
php -i | grep -E "error_log|display_errors|error_reporting"

echo -e "\n=== File Permissions ==="
ls -la /var/www/html/
ls -la /var/www/html/bin/

echo -e "\n=== Process Information ==="
ps aux | grep -E "apache|php"

echo -e "\n=== Apache Error Log ==="
tail -n 50 /var/log/apache2/error.log

echo -e "\n=== PHP Error Log ==="
if [ -f /var/www/html/var/logs/php_errors.log ]; then
    tail -n 50 /var/www/html/var/logs/php_errors.log
else
    echo "PHP error log not found"
fi

echo -e "\n=== Mautic Logs ==="
if [ -f /var/www/html/var/logs/dev.log ]; then
    tail -n 50 /var/www/html/var/logs/dev.log
else
    echo "Mautic dev log not found"
fi

echo -e "\n=== Volume Mount Information ==="
mount | grep -E "bind|volume" 