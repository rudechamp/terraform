
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
resource "aws_launch_configuration" "webserver-highly-available-lcec2" {
  image_id        = "ami-04505e74c0741db8d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2.id]

  #user_data = file("files/userdata.sh")

  user_data = <<-EOF
              #!/bin/bash
              echo "127.0.0.1 `hostname`" >> /etc/hosts
              sudo apt update
              sudo apt upgrade -y
              sudo apt install nginx -y
              sudo add-apt-repository -y ppa:ondrej/php;
              sudo apt update
              sudo apt install php7.4 php7.4-mysql php7.4-fpm -y
              ssudo ystemctl restart nginx
  EOF
  lifecycle {
    create_before_destroy = true
  }
}