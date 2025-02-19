terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.85.0"
    }
  }

   backend "s3" {
    bucket         = "tf-state-aks"
    key            = "terraform/state"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locks-aks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
}




resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test-2-vpc-aks"
  }
}
resource "aws_subnet" "public_subnet" {
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-aks-2a"
  }
}
resource "aws_internet_gateway" "test-ig" {
  vpc_id = aws_vpc.vpc.id

}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-ig.id
  }
  tags = {
    Name = "Public-route-table2-aks"
  }
}
resource "aws_route_table_association" "public-rta" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet.id
}
