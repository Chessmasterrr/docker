Mantis Bug Tracker is a free and open source, web-based bug tracking system.

The Dockerfile contains a mantis installation with the CustomReporter plugin (currently downloaded from my own fork, until support for the newest version is in the master branch of the plugin). The Dockerfile is part of a series of dockerfiles that are all reviewed by me, so that I can trust them. Therefore it has detailed comments to be as transparent as possible.

= Usage =
To use the docker container with mysql use the following commands:
`sudo docker run --name mysql --restart=always -e MYSQL_ROOT_PASSWORD=[PASSWORD] -e MYSQL_DATABASE=mantis -d mysql`
(optional: import old database with
`sudo docker exec -i mysql mysql -u root --password=[PASSWORD] mantis < [PathToSqlFile]`)
`sudo docker run --name mantis --restart=always -p 80 --link mysql -v /docker/mantis/main:/var/www/html/config -d chessmasterrr/mantis:latest`
(Note: In `/docker/mantis/main` I store the configuration file for mantis.)
To backup your database use:
`docker exec mysql sh -c 'exec mysqldump --all-databases -uroot -p"[PASSWORD]"' > [PathToBackupSqlFile]`
