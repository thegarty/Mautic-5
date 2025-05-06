FROM mautic/mautic:5-apache

# Install Amazon SES Mailer via Composer
RUN composer require symfony/amazon-mailer
