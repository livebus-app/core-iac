variable "rds-subnet-group-name" {
  description = "The name of the RDS subnet group"
  type        = string
}

variable "rds-security-group-id" {
  description = "The ID of the RDS security group"
  type        = string
}

variable "object-digest-lambda-arn" {
  description = "The ARN of the object digest lambda"
  type        = string
}