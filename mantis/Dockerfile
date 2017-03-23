FROM php:7.1.2-apache

### install preconditions ###
# mantis needs the following php extensions: gd mysqli mbstring curl fileinfo (see https://www.mantisbt.org/docs/master/en-US/Admin_Guide/html-desktop/)
# gd needs config settings for working with png and jpeg formats via docker-php-ext-configure
# for this config settings the following packages are needed: libpng-dev libjpeg-dev
# curl extension need the following package: libcurl4-openssl-dev
RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev libcurl4-openssl-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli mbstring curl fileinfo \
    && rm -rf /var/lib/apt/lists/*

### set values ###
# see https://www.mantisbt.org/download.php for version number
ENV MANTIS_VERSION 2.2.1
# see https://sourceforge.net/projects/mantisbt/files/mantis-stable/2.2.1/ (click on the i beside the file)
ENV MANTIS_URL https://sourceforge.net/projects/mantisbt/files/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz/download
ENV MANTIS_SHA1 7c79fcac7288c909899bd395383d0232daf3664f

### install application (with Custom Reporter plugin) ###
RUN set -xe \
    && curl -SL ${MANTIS_URL} -o mantis.tar.gz \
    && echo "${MANTIS_SHA1}  mantis.tar.gz" | sha1sum -c \
    && tar -xz --strip-components=1 -f mantis.tar.gz \
    && rm mantis.tar.gz \
    && curl -SL https://github.com/fmancardi/CustomReporter/archive/mantisbt.2.1.x.tar.gz -o customreporter.tar.gz \
    && mkdir plugins/CustomReporter \
    && tar -xz --strip-components=1 -f customreporter.tar.gz -C plugins/CustomReporter/ \
    && rm customreporter.tar.gz \
    && chown -R www-data:www-data .
