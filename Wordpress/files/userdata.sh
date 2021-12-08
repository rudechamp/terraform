#!/bin/bash
sudo echo "127.0.0.1 `hostname`" >> /etc/hosts
sudo apt update -y
sudo apt install mysql-client -y
sudo apt install nginx -y
sudo apt install php5 -y
sudo apt install php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-gd php5-xmlrp -y
sudo apt install php5-mysqlnd-ms -y
sudo service nginx restart
sudo wget -c https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sleep 20
sudo mkdir -p /var/www/html/
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo service nginx restart
sleep 20
