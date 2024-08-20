# Use PHP 8.2 image with FPM
FROM php:8.2-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy your Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your web files
COPY . /var/www/html

# Expose ports
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "service nginx start && php-fpm"]
