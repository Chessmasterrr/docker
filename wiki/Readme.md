MediaWiki is a free and open-source wiki software.

The Dockerfile contains a wiki installation. The Dockerfile is part of a series of dockerfiles that are all reviewed by me, so that I can trust them. Therefore it has detailed comments to be as transparent as possible.

# Usage

To use the docker container with mysql use the following commands:

`sudo docker run --name mysql --restart=always -e MYSQL_ROOT_PASSWORD=[PASSWORD] -e MYSQL_DATABASE=wiki -d mysql`

(optional: import old database with
`sudo docker exec -i mysql mysql -u root --password=[PASSWORD] wiki < [PathToSqlFile]`)

`sudo docker run --name wiki --restart=always -p 80 --link mysql -v /wiki/LocalSettings.php:/var/www/html/LocalSettings.php -v /wiki/images:/var/www/html/images -d chessmasterrr/wiki:latest`

To backup your database use:
`docker exec mysql sh -c 'exec mysqldump --all-databases -uroot -p"[PASSWORD]"' > [PathToBackupSqlFile]`
