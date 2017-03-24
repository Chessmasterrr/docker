FROM php:7.1.2-apache

### install preconditions ###
# mysqli is needed for connection to mysql database
# gd is needed for thumbnails
# gd needs config settings for working with png and jpeg formats via docker-php-ext-configure
# for this config settings the following packages are needed: libpng-dev libjpeg-dev
RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli \
    && rm -rf /var/lib/apt/lists/*

### set values ###
# see https://www.mediawiki.org/wiki/MediaWiki for version number
ENV MEDIAWIKI_VERSION 1.28.0
# see https://www.mediawiki.org/wiki/Download
ENV MEDIAWIKI_URL https://releases.wikimedia.org/mediawiki/1.28/mediawiki-${MEDIAWIKI_VERSION}.tar.gz

### install application ###
# import gpg keys to verify the downloads
COPY keys.txt keys.txt
RUN set -xe \
    && curl -SL ${MEDIAWIKI_URL} -o mediawiki.tar.gz \
    && curl -SL ${MEDIAWIKI_URL}.sig -o mediawiki.tar.gz.sig \
    && gpg --import keys.txt \
    && gpg --verify mediawiki.tar.gz.sig mediawiki.tar.gz \
    && tar -xz --strip-components=1 -f mediawiki.tar.gz \
    && rm mediawiki.tar.gz \
    && rm mediawiki.tar.gz.sig \
    && rm keys.txt \
    && chown -R www-data:www-data .
