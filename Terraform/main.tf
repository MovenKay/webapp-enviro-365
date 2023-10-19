resource "aws_instance" "ec2-1" {
  # (resource arguments)
  ami           = "ami-01dd271720c1ba44f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet-1.id
  tags = {
    Name = "Enviro-365-Instance1"
  }
}
resource "aws_instance" "ec2-2" {
  # (resource arguments)
  ami           = "ami-0694d931cee176e7d"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.public_subnet-2.id
  tags = {
    Name = "Enviro-365-Instance2"
  }
}

resource "aws_instance" "ansible-control" {
  # (resource arguments)
  ami           = "ami-01dd271720c1ba44f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet-1.id
  tags = {
    Name = "ansible-control"
  }
}

resource "aws_subnet" "public_subnet-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.20.1.0/24"

  tags = {
    Name = "Enviro-365-subnet-public1-eu-west-1a"
  }
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.20.2.0/24"

  tags = {
    Name = "Enviro-365-subnet-public2-eu-west-1b"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = "172.20.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Enviro-365-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Enviro-365-igw"
  }
}

resource "aws_security_group" "sg" {
  name        = "Enviro-365-SG"
  vpc_id      = aws_vpc.vpc.id
  description = "Enviro-365-SG"
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
 ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Enviro-365-SG"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Enviro-365-rtb-public"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  subnet_ids = [
    aws_subnet.public_subnet-1.id,  # Assuming "id" is the attribute containing the subnet ID
    aws_subnet.public_subnet-2.id,
  ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_lb" "nginx-lb" {
  name               = "enviro-365-ap-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.sg.id]
  subnets            = [aws_subnet.public_subnet-1.id, aws_subnet.public_subnet-2.id]

  enable_deletion_protection = true

  
  
}
