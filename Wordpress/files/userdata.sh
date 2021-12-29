#!/bin/bash
sudo echo "127.0.0.1 `hostname`" >> /etc/hosts
sudo apt update -y
sudo apt install nginx -y
sudo add-apt-repository -y ppa:ondrej/php;
sudo apt update
sudo apt install php7.4 php7.4-mysql php7.4-fpm -y
sudo mkdir -p /var/www/html
cd /var/www/html
sudo wget -c https://wordpress.org/wordpress-5.8.2.tar.gz
sudo tar -xzvf wordpress-5.8.2.tar.gz
sudo cp /tmp/wp-config.php /var/www/html/wordpress/wp-config.php
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl restart nginx