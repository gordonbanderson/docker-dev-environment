FROM php:7.0.4-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev --no-install-recommends \
    && docker-php-ext-install mcrypt
