#!/bin/bash
# exit when an error occurs in one line
set -eo pipefail

# check if data directory is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then

	# check if container is started with root user
	if [[ $EUID -ne 0 ]]; then
	   echo "This container must be started with --user root to initialize the data directory." 
	   exit 1
	fi
	TODO

	# check param MYSQL_DATABASE
	if [ -z ${MYSQL_DATABASE} ]; then
		echo "Parameter MYSQL_DATABASE not given, exiting!"
		exit 1
	fi

	# check param MYSQL_ROOT_PASSWORD
	if [ -z ${MYSQL_ROOT_PASSWORD} ]; then
		echo "Parameter MYSQL_ROOT_PASSWORD not given, exiting!"
		exit 1
	fi

	# initialize mysql with database and root user without password
	echo "Initialize mysql..."
	mysqld --initialize-insecure
	echo "Done!"

	# start server to interact with. Therefore SELECT 0 until the server is reachable via socket or exit after 30 seconds
	echo "Start mysql server..."
	mysqld --skip-networking --socket="/var/run/mysqld/mysqld.sock" & pid="$!"
	for i in {30..0}; do
		if echo 'SELECT 0' | mysql --protocol=socket -uroot -hlocalhost --socket="/var/run/mysqld/mysqld.sock" &> /dev/null; then
			break
		fi
		echo 'Starting in progress...'s
		sleep 1
	done
	if [ "$i" = 0 ]; then
		echo >&2 'MySQL init process failed.'
		exit 1
	fi
	echo "Done!"

	# create database
	echo "Create database..."
	mysql --protocol=socket -uroot -hlocalhost --socket="/var/run/mysqld/mysqld.sock" -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;"
	echo "Done!"

	# set password and allow root connection from anywhere
	echo "Set root password..."
	mysql --protocol=socket -uroot -hlocalhost --socket="/var/run/mysqld/mysqld.sock" -e "SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}');"
	mysql --protocol=socket -uroot -p${MYSQL_ROOT_PASSWORD} -hlocalhost --socket="/var/run/mysqld/mysqld.sock" -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
	echo "Done!"

	# kill local server started earlier
	echo "Killing mysql server..."
	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo >&2 'MySQL init process failed.'
		exit 1
	fi
	echo "Done!"
fi

# start server
echo "Start productive mysql server."
exec mysqld
