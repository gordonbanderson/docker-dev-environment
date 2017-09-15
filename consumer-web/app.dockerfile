FROM php:7.0.4-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev less vim git --no-install-recommends \
    && docker-php-ext-install mcrypt

RUN echo 'PS1="\[$(tput setaf 2)$(tput bold)[\]foodkit.cw@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bashrc
