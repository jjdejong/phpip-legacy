#!/bin/bash
# Uncomment if user should not be prompted for a MySQL password
# export DEBIAN_FRONTEND=noninteractive
echo "
********************************
Updating Ubuntu
********************************"
add-apt-repository universe
apt update
apt -y upgrade
echo "
********************************
Installing Apache, MySQL, PHP and Zend Framework
********************************"
apt -y install lamp-server^ zendframework git-core php7.2-simplexml
a2enmod rewrite
echo "127.0.0.1    phpip.local" >> /etc/hosts
echo "
********************************
Getting phpIP from GitHub
********************************"
cd /var/www/html
git clone https://github.com/jjdejong/phpip.git
cp phpip/install/conf/phpip.conf /etc/apache2/sites-enabled/
service apache2 reload
mv phpip/application/configs/application.ini.example phpip/application/configs/application.ini
echo "
********************************
Installing database
********************************"
mysql < phpip/install/phpip_sample.sql
echo "
Ready to go now. 
Point your browser to http://phpip.local and login with phpipuser:changeme
Report any issues on GitHub: https://github.com/jjdejong/phpip/issues"
