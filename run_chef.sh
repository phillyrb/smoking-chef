#!/bin/sh

cd /etc/chef
GIT_SSH="/etc/chef/ssh_wrapper" sudo -E git pull

if [ $? = 0 ]
then
    if [ "x$1" = "x" ] || [ ! -f "/etc/chef/chef-roles/${1}.js" ]
    then
        echo "usage: run_chef.sh <role>"
        echo
        echo "the <role>.js file must exist!"
        cd $OLDPWD
        exit 1
    fi

    sudo chef-solo -j /etc/chef/chef-roles/${1}.js -c /etc/chef/config.rb
else
    echo "'git pull' failed. please examine the /etc/chef directory!"
    cd $OLDPWD
    exit 1
fi

cd $OLDPWD
