# Use PHP 8.3 image with FPM
FROM php:8.3-fpm

# Install necessary dependencies, including Nginx, Supervisor, zip extension, and unzip
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y php8.3 php8.3-cli php8.3-fpm php8.3-zip php8.3-xml php8.3-mbstring php8.3-curl php8.3-intl php8.3-pdo php8.3-xmlrpc php8.3-soap php8.3-gd php8.3-mysql && \
    apt-get install -y libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_pgsql pgsql

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