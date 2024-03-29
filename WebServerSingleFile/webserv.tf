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
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "<h2>WebServer with IP: $myip"  >  /var/www/html/index.nginx-debian.html
sudo systemctl enable nginx
EOF

  tags = {
    Name  = "Web Server Build by Terraform"
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
    Name  = "WebServer SG"
  }
}
