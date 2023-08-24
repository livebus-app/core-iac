resource "aws_vpc" "livebus-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "livebus-vpc"
  }
}

resource "aws_internet_gateway" "livebus-igw" {
  vpc_id = aws_vpc.livebus-vpc.id

  tags = {
    Name = "livebus-igw"
  }
}

resource "aws_route_table" "livebus-public-route-table" {
  vpc_id = aws_vpc.livebus-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.livebus-igw.id
  }
}

resource "aws_route_table_association" "livebus-public-route-table-association" {
  subnet_id      = aws_subnet.livebus-public-pg-subnet.id
  route_table_id = aws_route_table.livebus-public-route-table.id
}

resource "aws_route_table_association" "livebus-public-route-table-association-2" {
  subnet_id      = aws_subnet.livebus-public-pg-subnet-2.id
  route_table_id = aws_route_table.livebus-public-route-table.id
}

resource "aws_subnet" "livebus-public-pg-subnet" {
  vpc_id     = aws_vpc.livebus-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "livebus-public-pg-subnet"
  }
}

resource "aws_subnet" "livebus-public-pg-subnet-2" {
  vpc_id     = aws_vpc.livebus-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "livebus-public-pg-subnet"
  }
}

resource "aws_security_group" "livebus-pg-sg" {
  name        = "livebus-pg-sg"
  description = "Allow RDS access"
  vpc_id      = aws_vpc.livebus-vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "livebus-pg-sg"
  }
}

resource "aws_db_subnet_group" "livebus-pg-subnet-group" {
  name       = "livebus-pg-subnet-group"
  subnet_ids = [aws_subnet.livebus-public-pg-subnet.id, aws_subnet.livebus-public-pg-subnet-2.id]

  tags = {
    Name = "livebus-pg-subnet-group"
  }
}