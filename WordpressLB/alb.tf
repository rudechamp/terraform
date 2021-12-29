resource "aws_lb" "webserver-ha-alb" {
  name                       = "webserver-ha-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ec2.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "webserver-tg" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-test-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}