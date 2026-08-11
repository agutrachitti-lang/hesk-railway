FROM php:8.1-apache

# Extensiones necesarias para HESK
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Asegurar que Apache utilice solamente MPM prefork
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true \
    && a2enmod mpm_prefork \
    && a2enmod rewrite

# Configuración de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Railway utiliza el puerto 8080
RUN echo "Listen 8080" > /etc/apache2/ports.conf

# Copiar HESK
COPY . /var/www/html/

# Permisos necesarios para HESK
RUN chmod -R 777 /var/www/html

EXPOSE 8080
