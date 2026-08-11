FROM php:8.1-apache

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN a2enmod rewrite

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN echo "Listen 8080" > /etc/apache2/ports.conf

COPY . /var/www/html/

RUN chmod -R 777 /var/www/html

EXPOSE 8080
