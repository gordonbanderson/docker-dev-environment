FROM php:7.0.4-fpm

RUN cat /etc/apt/sources.list

RUN apt-get update

# Install PostGRES PDO
RUN apt-get install -y libpq-dev jq git build-essential libxml2 libxml2-dev curl \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring zip soap

#Node
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash
RUN apt-get install -y nodejs && cd /var/www/ && npm install
RUN cd /var/www && npm install && npm install gulp -g

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Run composer, install libs - this does not work
#RUN composer install

#Change terminal prompt
RUN echo 'PS1="\[$(tput setaf 2)$(tput bold)[\]foodkit.api@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bashrc

ADD api.env /var/www/.env