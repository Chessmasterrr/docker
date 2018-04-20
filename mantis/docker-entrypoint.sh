#!/bin/bash
# exit when an error occurs in one line
set -eo pipefail

# set file permissions
chown -R www-data:www-data /var/www/html/config
chmod -R 440 /var/www/html/config

# start server
echo "Start productive mantis server."
exec apache2ctl -D FOREGROUND
