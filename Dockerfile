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
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/www/html/app/config \
    /var/www/html/media \
    /var/www/html/var/logs \
    /var/www/html/var/cache \
    /var/www/html/var/spool \
    /var/www/html/var/tmp \
    /var/www/html/public/s \
    /var/www/html/themes \
    /var/www/html/plugins

# Enable Apache debug logging
RUN echo "LogLevel debug" >> /etc/apache2/apache2.conf && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Create health check endpoint
RUN echo "<?php header('HTTP/1.1 200 OK'); echo 'OK'; ?>" > /var/www/html/public/s/health && \
    chown www-data:www-data /var/www/html/public/s/health && \
    chmod 644 /var/www/html/public/s/health

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Use Apache's default command
CMD ["apache2-foreground"]
