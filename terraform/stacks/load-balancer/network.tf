

resource "aws_vpc" "primary" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "nhcloud-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.100.0/24"
  availability_zone = "eun1-az1"

  tags = {
    Name = "Public a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.101.0/24"
  availability_zone = "eun1-az2"

  tags = {
    Name = "Public a"
  }
}


resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.200.0/24"
  availability_zone = "eun1-az1"

  tags = {
    Name = "Private a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.201.0/24"
  availability_zone = "eun1-az2"

  tags = {
    Name = "Private a"
  }
}

