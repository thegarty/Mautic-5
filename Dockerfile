FROM mautic/mautic:latest

# Install dependencies needed for Composer and Amazon Mailer
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install Symfony Amazon Mailer
RUN composer require symfony/amazon-mailer
