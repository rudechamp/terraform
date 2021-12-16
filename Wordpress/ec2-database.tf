
resource "aws_key_pair" "keypair1" {
  key_name   = "${var.stack}-keypairs"
  public_key = file(var.ssh_key)
}

data "template_file" "phpconfig" {
  template = file("files/conf.wp-config.php")

  vars = {
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
    db_user = var.username
    db_pass = var.password
    db_name = var.dbname
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  name                   = var.dbname
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  skip_final_snapshot    = true
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  depends_on = [
    aws_db_instance.mysql,
  ]

  key_name                    = aws_key_pair.keypair1.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true

  user_data = file("files/userdata.sh")

  tags = {
    Name = "EC2 Instance"
  }

  provisioner "file" {
    source      = "files/userdata.sh"
    destination = "/tmp/userdata.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "/tmp/userdata.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "file" {
    content     = data.template_file.phpconfig.rendered
    destination = "/tmp/wp-config.php"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/wp-config.php /var/www/html/wordpress/wp-config.php",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
  

  provisioner "file" {
    source      = "files/test.conf"
    destination = "/tmp/test.conf"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/test.conf /etc/nginx/sites-available/test.conf",
      "sudo ln -s /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled/",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  timeouts {
    create = "20m"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# This will create file /etc/nginx/sites-available/test.conf and symlink /etc/nginx/sites-enabled/test.conf
#resource "nginx_server_block" "ec2" {
#  filename = "test.conf"
#  enable   = true
#  content  = <<EOF
#server {
#            listen 80;
#            root /var/www/html/wordpress/public_html;
#            index index.php index.html;
#            server_name test.wordpress;

#	    access_log /var/log/nginx/wordpress.access.log;
#    	    error_log /var/log/nginx/wordpress.error.log;

#            location / {
#                         try_files $uri $uri/ =404;
#            }

#            location ~ \.php$ {
#                         include snippets/fastcgi-php.conf;
#                         fastcgi_pass unix:/run/php/php7.2-fpm.sock;
#            }

#            location ~ /\.ht {
#                         deny all;
#            }

#            location = /favicon.ico {
#                         log_not_found off;
#                         access_log off;
#            }

#           location = /robots.txt {
#                         allow all;
#                         log_not_found off;
#                         access_log off;
#           }

#            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
#                         expires max;
#                         log_not_found off;
#           }
#}
#EOF
#}