FROM php:8.1-apache-bullseye

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Configurar Apache  
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copiar HESK
COPY . /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Puerto
EXPOSE 80
