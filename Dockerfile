# Use PHP 8.2 image with FPM
FROM php:8.2-fpm

# Install necessary dependencies, including Nginx, Supervisor, zip extension, and unzip
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    libzip-dev \
    unzip

# Install the PHP zip extension
RUN docker-php-ext-install zip

# Copy your deployment configurations
COPY deployment/nginx.conf /etc/nginx/nginx.conf
COPY deployment/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy your web files
COPY src /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Laravel dependencies
RUN composer install

COPY .env.example /var/www/html/.env

RUN php artisan key:generate

# Ensure correct permissions
RUN chown -R www-data:www-data /var/www/html

# Expose ports
EXPOSE 80

# Start Supervisor, which will start both Nginx and PHP-FPM
CMD ["/usr/bin/supervisord"]