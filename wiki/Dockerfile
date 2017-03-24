FROM php:7.1.2-apache

### set values ###
# see https://www.mediawiki.org/wiki/MediaWiki for version number
ENV MEDIAWIKI_VERSION 1.28.0
# see https://www.mediawiki.org/wiki/Download
ENV MEDIAWIKI_URL https://releases.wikimedia.org/mediawiki/1.28/mediawiki-${MEDIAWIKI_VERSION}.tar.gz

COPY keys.txt keys.txt

### install application (with Custom Reporter plugin) ###
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
