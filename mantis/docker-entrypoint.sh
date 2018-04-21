#!/bin/bash
# exit when an error occurs in one line
set -eo pipefail

# set file permissions
chown -R www-data:www-data /var/www/
chmod -R 550 /var/www/

# start server
echo "Start productive mantis server."
exec apache2ctl -D FOREGROUND
