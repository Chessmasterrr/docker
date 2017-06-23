FROM php:7.1.2-apache

### install preconditions ###
# nextcloud needs the following additional php extensions: bz2 curl exif gd intl ldap mcrypt mysqli opcache pcntl pdo_mysql zip
# (see https://docs.nextcloud.com/server/12/admin_manual/installation/source_installation.html)
# bz2 extension needs libbz2-dev
# curl extension needs libcurl4-openssl-dev
# gd needs config settings for working with png and jpeg formats via docker-php-ext-configure
# for this config settings the following packages are needed: libpng-dev libjpeg-dev
# intl extension needs libicu-dev
# ldap extension needs libldap2-dev
# mcrypt extension needs libmcrypt-dev
# bzip2 is needed to decrompress the installation archive later on
# cron is needed for the automatic maintenance script later on
# libmagickwand-dev is needed for imagick
# rewrite is needed for redis
RUN set -xe \
    && apt-get update \
    && apt-get install -y \
        bzip2 \
        cron \
        libbz2-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmagickwand-dev \
        libmcrypt-dev \
        libpng-dev \
    && pecl install \
        imagick \
        redis-3.1.1 \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-enable redis \
    && docker-php-ext-install \
        bz2 \
        curl \
        exif \
        gd \
        intl \
        ldap \
        mcrypt \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

### set values ###
# see https://nextcloud.com/install/#instructions-server for version number
ENV NEXTCLOUD_VERSION 12.0.0
ENV NEXTCLOUD_URL https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2


### configure system ###
# configure opcache, see https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
# configure imagick and cron
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && a2enmod rewrite \
    && echo 'extension=imagick.so' > /usr/local/etc/php/conf.d/imagick.ini \
    && echo "*/15  *  *  *  www-data php -f /var/www/html/cron.php" >> /etc/crontab \
    && echo "#" >> /etc/crontab


### install application ###
# import gpg keys to verify the downloads, see https://nextcloud.com/nextcloud.asc
COPY keys.txt keys.txt
RUN set -xe \
    && curl -SL ${NEXTCLOUD_URL} -o nextcloud.tar.bz2 \
    && curl -SL ${NEXTCLOUD_URL}.asc -o nextcloud.tar.bz2.asc \
    && gpg --import keys.txt \
    && gpg --verify nextcloud.tar.bz2.asc nextcloud.tar.bz2 \
    && tar -xj --strip-components=1 -f nextcloud.tar.bz2 \
    && rm nextcloud.tar.bz2 \
    && rm nextcloud.tar.bz2.asc \
    && rm keys.txt \
&& chown -R www-data:www-data .
