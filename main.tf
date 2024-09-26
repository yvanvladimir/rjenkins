# PROVIDERS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.28.0"
    }
  }
}
 
 
provider "aws" {
  region     = var.aws_region
 
}
 
# DATASOURCE
data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"] # Author
 
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
 
# NETWORKING
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
 
  tags = {
    Name = "vpc-yvan"
 
  }
}
 
 
resource "aws_internet_gateway" "app_igw" { # INTERNET GATEWAY OR PUBLIC IP
  vpc_id = aws_vpc.app_vpc.id
 
  tags = {
    Name = "igw-yvan"
  }
}
 
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.vpc_public_subnets_cidr_block
 
  tags = {
    Name = "public-subnet-yvan"
  }
}
 
# ROUTING
resource "aws_route_table" "route_table_app" {
  vpc_id = aws_vpc.app_vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
 
  tags = {
    Name = "route-table-yvan"
  }
}
 
resource "aws_route_table_association" "app_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_app.id
}
 
# SECURITY GROUPS FOR NGINX CONFIG 
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP inbound traffic"
 
  # http access from anywhere 
  ingress {
    description = "https from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
}
 
# INSTANCE EC2
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.amazon_ami.id
  instance_type = "t2.micro"
  key_name      = "devops-yvan"
 
  tags = {
    Name = "ec2-yvan"
  }
 
  root_block_device {
    delete_on_termination = true
  }
 
  vpc_security_group_ids = ["${aws_security_group.nginx_sg.id}"]
 
 
  user_data = <<EOF
  #! /bin/bash 
  sudo amazon-linux-extras install -y nginx1.12
  sudo systemctl start nginx
  EOF
 
 
}
 
