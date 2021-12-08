#!/bin/bash
apt -y update
apt install -y nginx
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "<h2>WebServer with IP: $myip"  >  /var/www/html/index.nginx-debian.html
sudo systemctl enable nginx