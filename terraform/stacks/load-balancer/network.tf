

resource "aws_vpc" "primary" {
  cidr_block       = "${var.class_b_prefix}.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "nhcloud-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.100.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.101.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public a"
  }
}


resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.200.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Private a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.201.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Private a"
  }
}

