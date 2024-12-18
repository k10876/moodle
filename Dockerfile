FROM php:8.2-apache

# Install required PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libxml2-dev \
    libicu-dev \
    libpq-dev \
    git \
    unzip \
    && docker-php-ext-install \
    gd \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    soap \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Set recommended PHP.ini settings
RUN { \
    echo 'max_input_vars = 5000'; \
    echo 'memory_limit = 512M'; \
    echo 'post_max_size = 128M'; \
    echo 'upload_max_filesize = 128M'; \
    echo 'max_execution_time = 600'; \
} > /usr/local/etc/php/conf.d/moodle.ini

# Configure Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

# Copy the Moodle codebase
COPY . /var/www/html/

# Create moodledata directory with proper permissions
RUN mkdir -p /var/www/moodledata \
    && chown www-data:www-data /var/www/moodledata \
    && chmod 0770 /var/www/moodledata

# Set up proper permissions for web root
RUN chown -R root:www-data /var/www/html \
    && chmod -R 0755 /var/www/html \
    && find /var/www/html -type d -exec chmod 0755 {} \; \
    && find /var/www/html -type f -exec chmod 0644 {} \;

# Create writable directories for Moodle with proper permissions
RUN mkdir -p /var/www/html/cache \
             /var/www/html/local \
             /var/www/html/temp \
             /var/www/html/backup \
    && chown -R www-data:www-data /var/www/html/cache \
                                 /var/www/html/local \
                                 /var/www/html/temp \
                                 /var/www/html/backup \
    && chmod -R 0770 /var/www/html/cache \
                    /var/www/html/local \
                    /var/www/html/temp \
                    /var/www/html/backup