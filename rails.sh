#!/bin/bash

# Update APT and install git
sudo apt-get -y update
sudo apt-get -y install git curl nodejs libsqlite3-dev ruby-dev zlib1g-dev 

sudo gem install bundler

# Sort out the Gemfile to install rails
cat << EOF > /home/vagrant/Gemfile
source "https://rubygems.org"

gem "rails"
gem "spring"
gem "turbolinks"
EOF

bundle install

if [ -d /railsapp ] && [ -f /railsapp/config.ru ] ; then
	echo "App dir already exists and server appears to be running, setup has already been done"
else
	# Set up the dir for the rails app
	sudo mkdir /railsapp
	sudo chown vagrant:vagrant /railsapp

	# Init the rails app
	rails new /railsapp
	# Run the server, bind to the 0.0.0.0, so that it is visible from everywhere
	cd /railsapp
	rails server -d -b 0.0.0.0
	echo "Server set up and running. Please point your browser to http://localhost:3000"
fi

