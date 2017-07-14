#!/bin/bash

chown -R www-data:nogroup /app/config 


if [ ! -f "/app/config/config.php" ];
then
	cp /app/templates/config.php.dist /app/config/config.php
fi

if [ ! -f "/app/config/.htaccess" ];
then
	cp /app/templates/htaccess.template /app/config/.htaccess
fi

if [ -f "/var/www/html/.htaccess" ];
then
	unlink /var/www/html/.htaccess
fi

ln -s /app/config/.htaccess /var/www/html/.htaccess

mkdir -p -m 0770 /var/spool/dl
chown www-data:nogroup /var/spool/dl
chmod o= /var/spool/dl

MUST_ADD_ADMIN="false"
if [ ! -f "/var/spool/dl/data.sdb" ];
then
	MUST_ADD_ADMIN="true"
	echo "SQLite Database not found, creating an empty one and trying to add admin user..."
	echo "This might become useless if database configuration is changed to non SQLite endpoint"
	cd include/scripts/
	sqlite3 /var/spool/dl/data.sdb < db/sqlite.sql
	cd -
fi
# Let's do some dbupgrade, just in case
cd include/scripts/
php dbupgrade.php
cd -
chown www-data:nogroup /var/spool/dl/data.sdb
if [ "${MUST_ADD_ADMIN}" == "true" ];
then
	echo "As SQLite database is newly created admin user is added."
	add_admin_user.sh
fi
echo "
 ___ _   _ _____ ___  
|_ _| \ | |  ___/ _ \ 
 | ||  \| | |_ | | | |
 | || |\  |  _|| |_| |
|___|_| \_|_|   \___/ 

This image contains a tool to change admin password.
To change admin password try:
 docker exec $HOSTNAME change_admin_pass.sh YOUR_NEW_PASSWORD
or log into the web service and set a new one
"

if [ ! -d "/var/spool/dl/data" ];
then
	echo "Data spool directory not found, creating"
	mkdir -m 0770 /var/spool/dl/data
fi

chown www-data:www-data /var/spool/dl/data



apache2-foreground
