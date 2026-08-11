FROM php:8.1-apache

# Solucionar error MPM - deshabilitar otros módulos
RUN a2dismod mpm_event 2>/dev/null || true
RUN a2dismod mpm_worker 2>/dev/null || true

# Instalar extensiones necesarias
RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable mysqli

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Configurar Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copiar HESK
COPY . /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
