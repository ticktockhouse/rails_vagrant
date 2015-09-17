#!/bin/bash -x

# Update APT and install git
sudo apt-get -y update
sudo apt-get -y install git

# Install Postgres
sudo /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
sudo apt-get -y install postgresql libpq-dev postgresql-contrib

# Add postgres dirs
sudo mkdir -p /usr/local/pgsql/data
sudo chown postgres:postgres /usr/local/pgsql/data

# Create *.sql script to add alter role of vagrant user
sudo cat << EOF > altervagrant.sql
ALTER ROLE vagrant CREATEDB;
EOF

# If this file exists, we don't need to do the DB init stuff (idempotency)
if [ -f /usr/local/pgsql/data/pg_hba.conf ] ; then
	echo "DB already created"
# Otherwise, do the DB init stuff
else
	sudo -Hu postgres /usr/lib/postgresql/9.3/bin/initdb -D /usr/local/pgsql/data
	sudo -Hu postgres createuser vagrant
	sudo -Hu postgres psql -f altervagrant.sql
fi	

