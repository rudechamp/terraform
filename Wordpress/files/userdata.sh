#!/bin/bash
sudo apt -y update
#sudo apt -y upgrade
sudo apt install -y nginx
sudo apt install mysql
sudo apt install php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-json php7.2-opcache php7.2-mbstring php7.2-xml php7.2-gd php7.2-curl -y
sudo service php restart
sudo service nginx restart
sudo mkdir -p /var/www/html/wordpress/public_html
sudo cd /var/www/html/wordpress/public_html
wget -c https://wordpress.org/wordpress-5.8.2.tar.gz
tar -xzvf wordpress-5.8.2.tar.gz
sudo rsync -av wordpress/* /var/www/html/
sudo cd /var/www/html/wordpress/public_html
sudo chown -R www-data:www-data *
sudo chmod -R 755 *
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wordpress/public_html/wp-config.php
sudo cp /tmp/wordpress.conf /etc/nginx/sites-available/wordpress.conf
sudo cd /etc/nginx/sites-enabled
sudo ln -s ../sites-available/wordpress.conf .
sudo service nginx restart