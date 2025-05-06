FROM mautic/mautic:5-apache

# Set default environment variables
ENV DOCKER_MAUTIC_ROLE=mautic_web \
    PHP_INI_VALUE_DATE_TIMEZONE=UTC \
    PHP_INI_VALUE_MEMORY_LIMIT=512M \
    PHP_INI_VALUE_UPLOAD_MAX_FILESIZE=512M \
    PHP_INI_VALUE_POST_MAX_FILESIZE=512M \
    PHP_INI_VALUE_MAX_EXECUTION_TIME=300 \
    PHP_INI_VALUE_DISPLAY_ERRORS=On \
    PHP_INI_VALUE_ERROR_REPORTING=E_ALL \
    PHP_INI_VALUE_LOG_ERRORS=On \
    PHP_INI_VALUE_ERROR_LOG=/var/www/html/var/logs/php_errors.log

# Install debugging tools
RUN apt-get update && apt-get install -y \
    vim \
    htop \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/www/html/app/config \
    /var/www/html/media \
    /var/www/html/var/logs

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html

# Add debug script
COPY debug.sh /usr/local/bin/debug.sh
RUN chmod +x /usr/local/bin/debug.sh

# Enable Apache debug logging
RUN echo "LogLevel debug" >> /etc/apache2/apache2.conf

# Create a health check script
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh
