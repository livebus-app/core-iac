// create bucket live-digest

resource "aws_db_instance" "livebus" {
  identifier             = "livebus"
  db_name = "livebus"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "15"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [var.pg-security-group-id]
  username = "root"
  password = "root12345"
  backup_retention_period = 0
  db_subnet_group_name    = var.pg-subnet-group-name
}

resource "aws_dynamodb_table" "lvb-analysis-payload" {
  name           = "lvb-analysis-payload"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_s3_bucket" "livebus-frames-storage" {
  bucket = "lvb-frames-storage"
  acl    = "private"
  tags = {
    Name = "lvb-frames-storage"
  }
}