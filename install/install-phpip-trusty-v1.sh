#!/bin/bash
# Uncomment if user should not be prompted for a MySQL password
# export DEBIAN_FRONTEND=noninteractive
echo "
********************************
Updating Ubuntu
********************************"
apt-get update
apt-get -y upgrade
echo "
********************************
Installing Apache, MySQL, PHP and Zend Framework. 
You will be prompted for a new MySQL password - provide it and remember it
********************************"
apt-get -y install lamp-server^ zend-framework-bin git-core
sed -i "s/^#application\/x-httpd-php/application\/x-httpd-php/" /etc/mime.types
a2enmod rewrite
echo "127.0.0.1    phpip.local" >> /etc/hosts
sed -i "s/^; include/include/" /etc/php5/mods-available/zend-framework.ini
php5enmod zend-framework
sed -i "s/^short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
echo "
********************************
Getting phpIP from Google Code
********************************"
cd /var/www
git clone https://code.google.com/p/phpip/
cp phpip/install/conf/phpip.conf /etc/apache2/sites-enabled/
service apache2 reload
echo "
********************************
Installing database.
When prompted for a password, enter the MySQL password defined earlier
********************************"
mysql -u root -p < phpip/install/phpip_skel-current.sql