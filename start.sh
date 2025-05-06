#!/bin/bash
set -e

# Logging functions
log_info() {
    echo "ℹ️  INFO: $1"
}

log_success() {
    echo "✅ SUCCESS: $1"
}

log_error() {
    echo "❌ ERROR: $1"
}

log_warning() {
    echo "⚠️  WARNING: $1"
}

log_step() {
    echo "🔄 STEP: $1"
}

log_debug() {
    echo "🔍 DEBUG: $1"
}

# Print system information
log_info "Starting Mautic container..."
log_debug "Current directory: $(pwd)"
log_debug "Container hostname: $(hostname)"
log_debug "PHP version: $(php -v | head -n1)"
log_debug "Apache version: $(apache2 -v | head -n1)"

# Check volume mount
log_step "Checking volume mount..."
if mount | grep -q "/var/www/html"; then
    log_success "Volume mounted successfully"
    log_debug "Mount details: $(mount | grep '/var/www/html')"
else
    log_error "Volume not mounted properly"
    exit 1
fi

# Run initialization script
log_step "Running initialization script..."
if /usr/local/bin/init.sh; then
    log_success "Initialization completed"
else
    log_error "Initialization failed"
    exit 1
fi

# Create health check endpoint
log_step "Creating health check endpoint..."
mkdir -p /var/www/html/public/s
echo "<?php echo 'OK'; ?>" > /var/www/html/public/s/health
chown www-data:www-data /var/www/html/public/s/health
chmod 644 /var/www/html/public/s/health
log_success "Health check endpoint created at /var/www/html/public/s/health"

# Set proper permissions
log_step "Setting permissions..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 775 {} \;
find /var/www/html -type f -exec chmod 664 {} \;
log_success "Permissions set successfully"

# Make sure the console is executable
log_step "Checking Mautic console..."
if [ -f /var/www/html/bin/console ]; then
    chmod +x /var/www/html/bin/console
    log_success "Mautic console is executable"
else
    log_error "Mautic console not found"
    log_debug "Directory contents of /var/www/html/bin/:"
    ls -la /var/www/html/bin/
    exit 1
fi

# Check critical directories
log_step "Checking critical directories..."
for dir in "/var/www/html/app/config" "/var/www/html/media" "/var/www/html/var/logs" "/var/www/html/var/cache"; do
    if [ -d "$dir" ]; then
        log_success "Directory exists: $dir"
    else
        log_error "Directory missing: $dir"
        exit 1
    fi
done

# Check log files
log_step "Checking log files..."
if [ -f /var/log/apache2/error.log ]; then
    log_debug "Last 3 lines of Apache error log:"
    tail -n 3 /var/log/apache2/error.log
else
    log_warning "Apache error log not found"
fi

if [ -f /var/www/html/var/logs/php_errors.log ]; then
    log_debug "Last 3 lines of PHP error log:"
    tail -n 3 /var/www/html/var/logs/php_errors.log
else
    log_warning "PHP error log not found"
fi

# Run debug script
log_step "Running debug script..."
/usr/local/bin/debug.sh

# Check if Apache is running
log_step "Checking Apache status..."
if pgrep apache2 > /dev/null; then
    log_success "Apache is running"
else
    log_error "Apache is not running"
    exit 1
fi

# Start Apache in foreground
log_info "Starting Apache in foreground mode..."
log_debug "Apache configuration:"
apache2ctl -S
log_debug "Loaded modules:"
apache2ctl -M

exec "$@" 