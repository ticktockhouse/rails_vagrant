#!/bin/bash -x

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


# Set up the dir for the rails app
sudo mkdir /railsapp
sudo chown vagrant:vagrant /railsapp
cd /railsapp

# Init the rails app
rails new /railsapp
# Run the server
rails s &

echo "Current end of provisioning script. If you got here, it's all over"
