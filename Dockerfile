FROM php:8.1-fpm-bullseye

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY . /var/www/html/

RUN echo 'server { listen 80; server_name _; root /var/www/html; index index.php; location / { try_files $uri $uri/ /index.php?$query_string; } location ~ \.php$ { fastcgi_pass 127.0.0.1:9000; fastcgi_index index.php; fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; include fastcgi_params; } }' > /etc/nginx/sites-available/default

RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html && mkdir -p /run/php

EXPOSE 80

CMD php-fpm && nginx -g "daemon off;"
