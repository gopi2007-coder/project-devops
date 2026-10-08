resource "aws_vpc" "devops_vpc" {
  cidr_block = "11.0.0.0/16"

  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops-igw"
  }
}

resource "aws_subnet" "devops_subnet_1" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "11.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-subnet-1"
  }
}

resource "aws_subnet" "devops_subnet_2" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "11.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-subnet-2"
  }
}

resource "aws_route_table" "devops_route_table" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "devops-route-table"
  }
}

resource "aws_route_table_association" "devops_route_table_association_1" {
  subnet_id      = aws_subnet.devops_subnet_1.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_route_table_association" "devops_route_table_association_2" {
  subnet_id      = aws_subnet.devops_subnet_2.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_security_group" "devops_security_group" {
  name   = "devops-security-group"
  vpc_id = aws_vpc.devops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "devops-security-group"
  }
}

resource "aws_instance" "devops_instance_1" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.devops_subnet_1.id

  vpc_security_group_ids = [
    aws_security_group.devops_security_group.id
  ]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ubuntu
  EOF

  tags = {
    Name = "devops-instance-1"
  }
}

resource "aws_instance" "devops_instance_2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.devops_subnet_2.id

  vpc_security_group_ids = [
    aws_security_group.devops_security_group.id
  ]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ubuntu
  EOF

  tags = {
    Name = "devops-instance-2"
  }
}