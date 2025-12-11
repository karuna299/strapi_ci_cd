output "ec2_ip" {
  value = aws_instance.karuna_strapi_ec2.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.karuna_strapi.address
}