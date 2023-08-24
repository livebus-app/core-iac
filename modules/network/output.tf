output "pg-subnet-group-name" {
  value = aws_db_subnet_group.livebus-pg-subnet-group.name
}

output "pg-security-group-id" {
  value = aws_security_group.livebus-pg-sg.id
}
