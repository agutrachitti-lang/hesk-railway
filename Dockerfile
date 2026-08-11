FROM php:8.1-apache

# Instalar extensiones PHP necesarias para HESK
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Eliminar TODOS los MPM que puedan venir habilitados
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load \
    && rm -f /etc/apache2/mods-enabled/mpm_*.conf

# Habilitar solamente prefork
RUN a2enmod mpm_prefork

# Habilitar rewrite para HESK
RUN a2enmod rewrite

# Configuración básica de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Railway utiliza el puerto 8080
RUN sed -i 's/^Listen .*/Listen 8080/' /etc/apache2/ports.conf

# Copiar HESK
COPY . /var/www/html/

# Permisos
RUN chmod -R 777 /var/www/html

# Verificar MPM durante el BUILD
RUN apache2ctl -M | grep mpm

EXPOSE 8080
