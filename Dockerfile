FROM mautic/mautic:5-apache

# Set default environment variables
ENV DOCKER_MAUTIC_ROLE=mautic_web \
    PHP_INI_VALUE_DATE_TIMEZONE=UTC \
    PHP_INI_VALUE_MEMORY_LIMIT=512M \
    PHP_INI_VALUE_UPLOAD_MAX_FILESIZE=512M \
    PHP_INI_VALUE_POST_MAX_FILESIZE=512M \
    PHP_INI_VALUE_MAX_EXECUTION_TIME=300

# Create necessary directories
RUN mkdir -p /var/www/html/app/config \
    /var/www/html/media \
    /var/www/html/var/logs

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html 