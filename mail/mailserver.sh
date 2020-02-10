#!/bin/bash
set -e

chown -R vmail:vmail /var/vmail
chmod -R 770 /var/vmail
chmod 440 /etc/dovecot/dovecot-sql.conf
chmod -R 640 /etc/postfix/sql
chown -R _rspamd:_rspamd /var/lib/rspamd/dkim
chmod 440 /var/lib/rspamd/dkim/*

postmap /etc/postfix/without_ptr
newaliases

service postfix reload
service postfix restart
dovecot -F
