#!/usr/bin/env bash

sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8

sudo apt-get update
sudo apt-get install -y build-essential git curl libxslt1-dev libxml2-dev libssl-dev

# postgres
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main " | sudo tee -a /etc/apt/sources.list.d/pgdg.list
sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-9.3 libpq-dev
echo '# "local" is for Unix domain socket connections only
local   all             all                                  trust
 IPv4 local connections:
host    all             all             0.0.0.0/0            trust
 IPv6 local connections:
host    all             all             ::/0                 trust' | sudo tee /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf
sudo /etc/init.d/postgresql restart
sudo su - postgres -c 'createuser -s vagrant'

# mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server

# redis
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:rwky/redis
sudo apt-get update
sudo apt-get install -y redis-server

# rvm and ruby
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby'
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'

#node
curl https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
echo "source /home/vagrant/.nvm/nvm.sh" >> /home/vagrant/.profile
source /home/vagrant/.profile
nvm install 7.10.0
nvm alias default 7.10.0

echo "All done installing!
Next steps: type 'vagrant ssh' to log into the machine."
