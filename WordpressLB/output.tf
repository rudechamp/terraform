# output "ami_id" {
#   value = data.aws_ami.ubuntu.id
# }

# output "Login" {
#   value = "ssh -i ${aws_key_pair.keypair1.key_name} ubuntu@${aws_instance.ec2.public_ip}"
# }

output "azs" {
  value = data.aws_availability_zones.azs.*.names
}

output "db_access_from_ec2" {
  value = "mysql -h ${aws_db_instance.mysql.address} -P ${aws_db_instance.mysql.port} -u ${var.username} -p${var.password}"
}

# output "access" {
#   value = "http://${aws_instance.ec2.public_ip}/index.php"
# }

# output "web_loadbalancer_url" {
#   value = aws_elb.webserver-ha-elb.dns_name
# }

output "alb_dns_name" {
  value = aws_lb.webserver-ha-alb.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.webserver-tg.arn
}