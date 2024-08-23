# Use PHP 8.3 image with FPM
FROM php:8.3-fpm

# Install necessary dependencies, including Nginx, Supervisor, zip extension, and unzip
RUN apt-get update && \
    apt-get install -y software-properties-common libzip-dev unzip nano python3-pip && \
    apt-get install -y python3-software-properties python3-launchpadlib && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    docker-php-ext-install zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the PHP zip extension
RUN docker-php-ext-install zip

# Copy your web files
COPY src /var/www/html
# COPY src/.env.example /var/www/html/.env

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Laravel dependencies
RUN composer install

RUN php artisan key:generate

# Ensure correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose ports
EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html/public"]