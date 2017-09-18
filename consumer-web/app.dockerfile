FROM php:7.0.4-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev less vim curl zip zlib1g-dev jq git --no-install-recommends \
    && docker-php-ext-install mcrypt mbstring zip

RUN echo 'PS1="\[$(tput setaf 2)$(tput bold)[\]foodkit.cw@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bashrc

# Configure php-fpm to log errors
RUN sed -i '/^;catch_workers_output/ccatch_workers_output = yes' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_flag\[display_errors\]/cphp_flag[display_errors] = off' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_admin_value\[error_log\]/cphp_admin_value[error_log] = /var/log/php/fpm-error.log' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_admin_flag\[log_errors\]/cphp_admin_flag[log_errors] = on' "/usr/local/etc/php-fpm.d/www.conf"


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo 'source /root/.bash_aliases' >> /root/.bashrc

#Run composer, install libs - this does not work
#RUN composer install

