provider "aws" {
  region = "us-east-1"

}


resource "aws_instance" "Webserver" {
  ami                    = "ami-083654bd07b5da81d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Webserver.id]
  user_data              = <<EOF
#!/bin/bash
apt -y update
apt install -y nginx
apt install php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-json php7.2-opcache php7.2-mbstring php7.2-xml php7.2-gd php7.2-curl
mkdir -p /var/www/html/wordpress/public_html
cd /var/www/html/wordpress/public_html
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
mv wordpress/* .
rm -rf wordpress
cd /var/www/html/wordpress/public_html
chown -R www-data:www-data *
chmod -R 755 *
sudo systemctl enable nginx
EOF

  tags = {
    Name = "Web Server Build by Terraform"
  }
}


resource "aws_security_group" "Webserver" {
  name        = "WebServer SG"
  description = "SecurityGroup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServer SG"
  }
}
