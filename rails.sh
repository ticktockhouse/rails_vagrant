#!/bin/bash -x

sudo apt-get -y update
sudo apt-get -y install git

sudo /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
sudo apt-get -y install postgresql libpq-dev postgresql-contrib

sudo mkdir -p /usr/local/pgsql/data
sudo chown postgres:postgres /usr/local/pgsql/data
if [ -d /usr/local/pgsql/data ] ; then
	echo "DB already created"
else
	sudo -Hu postgres /usr/lib/postgresql/9.3/bin/initdb -D /usr/local/pgsql/data
	sudo -Hu postgres createuser vagrant
fi	

cat << EOF  | su - postgres -c psql
ALTER ROLE vagrant CREATEDB;
CREATE EXTENSION dblink;
IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'mydb') THEN
   RAISE NOTICE 'Database already exists'; 
ELSE
   PERFORM dblink_exec('dbname=' || current_database()  -- current db
                     , 'CREATE DATABASE mydb');
END IF;

EOF

#cat << EOF | su - postgres -c psql
#SELECT datname FROM pg_database;
#EOF
#|grep sampledb

