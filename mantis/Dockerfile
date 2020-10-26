FROM php:apache

### set values ###
# see https://www.mantisbt.org/download.php for version number
ENV MANTIS_VERSION 2.24.3
# see https://sourceforge.net/projects/mantisbt/files/mantis-stable/{VERSION}/ (click on the i beside the file)
ENV MANTIS_URL https://sourceforge.net/projects/mantisbt/files/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz/download
ENV MANTIS_SHA1 fe3d8136935c7194848a790826043ef0c76c2f53

WORKDIR /var/www/html
### install application (with Custom Reporter plugin) ###
RUN set -xe \
    && docker-php-ext-install mysqli \
    && curl -L ${MANTIS_URL} -o mantis.tar.gz \
    && echo "${MANTIS_SHA1}  mantis.tar.gz" | sha1sum -c \
    && tar -xz --strip-components=1 -f mantis.tar.gz \
    && rm mantis.tar.gz \
    && curl -L https://github.com/mantisbt-plugins/CustomReporter/archive/v2.0.0.tar.gz -o customreporter.tar.gz \
    && mkdir plugins/CustomReporter \
    && tar -xz --strip-components=1 -f customreporter.tar.gz -C plugins/CustomReporter/ \
    && rm customreporter.tar.gz

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
