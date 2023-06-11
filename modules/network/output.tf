output "rds-subnet-group-name" {
  value = aws_db_subnet_group.livebus-rds-subnet-group.name
}

output "rds-security-group-id" {
  value = aws_security_group.livebus-rds-sg.id
}
