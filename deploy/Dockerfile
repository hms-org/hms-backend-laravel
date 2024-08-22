# Use PHP 8.2 image with FPM
FROM php:8.2-fpm

# Install Nginx and Supervisor
RUN apt-get update && apt-get install -y nginx supervisor

# Copy your Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy your web files
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Laravel dependencies
RUN composer install

RUN php artisan key:generate

# Expose ports
EXPOSE 80

# Start Supervisor, which will start both Nginx and PHP-FPM
CMD ["/usr/bin/supervisord"]
