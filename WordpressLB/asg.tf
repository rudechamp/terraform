resource "aws_autoscaling_group" "ec2-instance-asf" {
  launch_configuration = aws_launch_configuration.webserver-highly-available-lcec2.id
  vpc_zone_identifier  = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  min_size             = 3
  max_size             = 5
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "ec2-instance-asf" {
  autoscaling_group_name = aws_autoscaling_group.ec2-instance-asf.id
  alb_target_group_arn   = aws_lb_target_group.webserver-tg.arn
}