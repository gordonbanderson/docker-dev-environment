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

RUN apt-get install -y vim

#Change terminal prompt
RUN echo 'PS1="\[$(tput setaf 2)$(tput bold)[\]foodkit.api@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bashrc
RUN echo 'source /root/.bash_aliases' >> /root/.bashrc

#This does not work, probably due to it being a mounted folder
#ADD api.env /var/www/.env

ADD api.bash_aliases /root/.bash_aliases

#TODO add these above later
RUN apt-get install -y htop strace traceroute multitail


#Enable php-fm error logging /usr/local/etc/php-fpm.conf - logs should appear in /usr/local/var/log/

RUN sed -i '/^;catch_workers_output/ccatch_workers_output = yes' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_flag\[display_errors\]/cphp_flag[display_errors] = off' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_admin_value\[error_log\]/cphp_admin_value[error_log] = /var/log/php/fpm-error.log' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_admin_flag\[log_errors\]/cphp_admin_flag[log_errors] = on' "/usr/local/etc/php-fpm.d/www.conf"
