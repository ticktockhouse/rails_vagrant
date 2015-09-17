#!/bin/bash -x

sudo apt-get -y update
sudo apt-get -y install git

sudo /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
sudo apt-get -y install postgresql libpq-dev postgresql-contrib

sudo mkdir -p /usr/local/pgsql/data
sudo chown postgres:postgres /usr/local/pgsql/data
sudo cat << EOF > altervagrant.sql
ALTER ROLE vagrant CREATEDB;
EOF
sudo -Hu postgres psql -f altervagrant.sql
if [ -f /usr/local/pgsql/data/pg_hba.conf ] ; then
	echo "DB already created"
else
	sudo -Hu postgres /usr/lib/postgresql/9.3/bin/initdb -D /usr/local/pgsql/data
	sudo -Hu postgres createuser vagrant
	sudo su - postgres -c  echo "ALTER ROLE vagrant CREATEDB;" | psql postgres
fi	

#echo
