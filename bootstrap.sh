#!/bin/sh

RUBYGEMS_VERSION=1.5.3

sudo ntpdate time.nist.gov

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert git-core vim

git clone git://github.com/erikh/smoking-chef.git chef

if [ $? = 0 ]
then
    sudo mv chef /etc/chef
    sudo chown -R root:root /etc/chef
    sudo chmod 700 /etc/chef
else
    echo "'git clone' did not complete."
    exit 1
fi

wget http://production.cf.rubygems.org/rubygems/rubygems-${RUBYGEMS_VERSION}.tgz
tar zxf rubygems-${RUBYGEMS_VERSION}.tgz
cd rubygems-${RUBYGEMS_VERSION}
sudo ruby setup.rb --no-format-executable

sudo cp /etc/chef/gemrc /etc/gemrc
sudo gem install chef

sudo mkdir -p /root/.ssh
sudo cp /etc/chef/known_hosts /root/.ssh/known_hosts
sudo chown root:root /root/.ssh
sudo chmod 600 /root/.ssh/known_hosts

sudo /etc/chef/run_chef.sh bootstrap
