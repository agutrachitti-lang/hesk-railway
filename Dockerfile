FROM php:8.1-apache

# Extensiones PHP necesarias para HESK
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Eliminar cualquier MPM habilitado
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load \
    /etc/apache2/mods-enabled/mpm_*.conf

# Habilitar SOLO prefork
RUN a2enmod mpm_prefork
RUN a2enmod rewrite

# Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Railway usa 8080
RUN sed -i 's/^Listen .*/Listen 8080/' /etc/apache2/ports.conf

# Copiar HESK
COPY . /var/www/html/

# Permisos
RUN chmod -R 777 /var/www/html

# Crear script de inicio
RUN printf '#!/bin/bash\n\
rm -f /etc/apache2/mods-enabled/mpm_*.load\n\
rm -f /etc/apache2/mods-enabled/mpm_*.conf\n\
ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load\n\
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf\n\
exec apache2-foreground\n' > /usr/local/bin/start-apache.sh \
    && chmod +x /usr/local/bin/start-apache.sh

EXPOSE 8080

CMD ["/usr/local/bin/start-apache.sh"]
