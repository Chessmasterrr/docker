FROM chessmasterrr/ubuntu:latest

# install needed packages:
# 	apache2 as webserver
# 	php with needed modules:
# 		libapache2-mod-php for integration in apache
# 		php-mysql for connection to mysql
# 		php-mbstring and php-xml for dependend programs
#		libpng-dev and libjpeg-dev for support for jpg and png files
#		gd for thumbnails
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apache2 php libapache2-mod-php php-mysql php-mbstring php-xml libpng-dev libjpeg-dev php-gd \
	&& rm -rf /var/lib/apt/lists/*

# logs should go to stdout / stderr and remove default index.html
RUN set -ex \
	&& . "/etc/apache2/envvars" \
	&& ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log" \
	&& rm /var/www/html/index.html

# set port and start apache in foreground to prevent the container from exiting
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
