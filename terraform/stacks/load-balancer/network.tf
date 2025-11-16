

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

  cidr_block        = "10.20.0.0/20"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "nhcloud-subnet-public1-eu-north-1a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.16.0/20"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "nhcloud-subnet-public2-eu-north-1b"
  }
}


resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.128.0/20"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "nhcloud-subnet-private1-eu-north-1a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.20.144.0/20"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "nhcloud-subnet-private2-eu-north-1b"
  }
}

