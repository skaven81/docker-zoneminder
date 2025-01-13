Zoneminder in Docker
====================

A hacky but functional implementation of Zoneminder in Docker

Building
--------

    docker build -t skaven/zoneminder:<version> .

Test run
--------

    docker-compose up -d

To restart, mariadb gets hung up so you have to delete the volumes to restart:

    docker-compose down --volumes && docker-compose up -d

Production run
--------------

See https://github.com/skaven81/HomeServices

* MariaDB container needs to be visible to zoneminder as `mariadb` with root password `flargle`
* Make sure MariaDB container mounts the database dir to an external volume
* Zoneminder container needs several mapped mounts to store data:
  * `/var/cache/zoneminder/{events,images,temp}` - captured data from cameras
  * `/var/cache/zoneminder/cache` - maybe ... data here gets regenerated on the fly, probably should keep it in the container
  * `/var/log/zoneminder` - zoneminder logs
  * `/var/log/apache2` - apache logs

Database update/recovery
------------------------

If the database gets wiped out, exec into the Zoneminder container and run `zmupdate.pl -f` to
regenerate the configuration.
