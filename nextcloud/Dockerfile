FROM chessmasterrr/php:latest

### install preconditions ###
# (see https://docs.nextcloud.com/server/13/admin_manual/installation/source_installation.html)
# nextcloud needs the following additional php modules: apcu bz2 curl gmp intl ldap smbclient zip
# other programs needed: cron ffmpeg LibreOffice
RUN set -xe \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y -q \
        php-apcu \
        php-bz2 \
        php-curl \
        php-gmp \
        php-imagick \
        php-imap \
        php-intl \
        php-ldap \
        php-smbclient \
        php-zip \
        cron \
        ffmpeg \
        libreoffice \
    && rm -rf /var/lib/apt/lists/*

### set values ###
# see https://nextcloud.com/install/#instructions-server for version number
ENV NEXTCLOUD_VERSION 15.0.7
ENV NEXTCLOUD_URL https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2

### configure system ###
# configure opcache, see https://docs.nextcloud.com/server/14/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
# configure cron
# configure large file uploads, see https://docs.nextcloud.com/server/14/admin_manual/configuration_files/big_file_upload_configuration.html
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /etc/php/7.2/apache2/conf.d/opcache-recommended.ini \
    && a2enmod rewrite \
    && sed -i '$ d' /etc/crontab \
    && echo '*/15 *  * * *  www-data php -f /var/www/html/cron.php' >> /etc/crontab \
    && echo '#' >> /etc/crontab \
    && cron \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 2G/g' /etc/php/7.2/apache2/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 2G/g' /etc/php/7.2/apache2/php.ini \
    && sed -i 's/max_input_time = 60/max_input_time = 3600/g' /etc/php/7.2/apache2/php.ini \
    && sed -i 's/max_execution_time = 30/max_execution_time = 3600/g' /etc/php/7.2/apache2/php.ini \
    && sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/7.2/apache2/php.ini

WORKDIR /var/www/html
### install application ###
# import gpg keys to verify the downloads, see https://nextcloud.com/nextcloud.asc
# set upload size
COPY keys.txt keys.txt
RUN set -xe \
    && wget --no-check-certificate --no-verbose ${NEXTCLOUD_URL} -O nextcloud.tar.bz2 \
    && wget --no-check-certificate --no-verbose ${NEXTCLOUD_URL}.asc -O nextcloud.tar.bz2.asc \
    && gpg --import keys.txt \
    && gpg --verify nextcloud.tar.bz2.asc nextcloud.tar.bz2 \
    && tar -xj --strip-components=1 -f nextcloud.tar.bz2 \
    && rm nextcloud.tar.bz2 \
    && rm nextcloud.tar.bz2.asc \
    && rm keys.txt \
    && chown -R www-data:www-data . \
    && sed -i 's/php_value upload_max_filesize 511M/php_value upload_max_filesize 2G/g' /var/www/html/.htaccess \
    && sed -i 's/php_value post_max_size 511M/php_value post_max_size 2G/g' /var/www/html/.htaccess


### run container ###
COPY startup.sh /usr/local/bin/
CMD ["startup.sh"]
