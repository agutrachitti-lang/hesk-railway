FROM php:8.1-apache 
 
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli 
 
RUN a2enmod rewrite 
 
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf 
 
COPY . /var/www/html/ 
 
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html 
 
EXPOSE 80 
