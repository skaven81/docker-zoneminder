#!/bin/bash

while true; do
    echo "Waiting for MySQL to start..."
    mysql -u root -pflargle -h mariadb -P 3306 -e "SELECT 1;" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Database connection successful."
        break
    else
        echo "Failed to connect to the database."
        sleep 1
    fi
done

echo "Updating database schema..."
mysql -h mariadb -P 3306 -u root -pflargle < /usr/share/zoneminder/db/zm_create.sql
mysql -h mariadb -P 3306 -u root -pflargle -e "grant lock tables,alter,drop,select,insert,update,delete,create,index,alter routine,create routine, trigger,execute,references on zm.* to 'zmuser'@'%' identified by 'zmpass';"

echo "Starting Apache"
apachectl start

echo "Starting ZoneMinder"
/usr/bin/zmpkg.pl start

shutdown ( ) {
    echo "Caught termination signal, shutting down"
    /usr/bin/zmpkg.pl stop
    killall -QUIT xtail
}

trap shutdown TERM INT
while true; do
    echo "Watching logs"
    timeout -s QUIT -k1 60m xtail /var/log/zoneminder/* /var/log/apache2/zoneminder*
done
