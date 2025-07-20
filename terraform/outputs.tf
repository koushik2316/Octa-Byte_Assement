output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.app.public_dns
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint

}
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
