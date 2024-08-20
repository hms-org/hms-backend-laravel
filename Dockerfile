FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libxml2-dev \
    && docker-php-ext-install zip pdo_mysql dom xml

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set work directory
WORKDIR /var/www/html

# Copy project files ke dalam container
COPY . .

# Install PHP dependencies
RUN composer install 

RUN composer update

# Expose port 80
EXPOSE 80

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Run Apache
CMD ["apache2-foreground"]
