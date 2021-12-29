resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.vpc.id
  #map_public_ip_on_launch = true
  cidr_block        = "192.168.1.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name = "${var.stack}-public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.vpc.id
  #map_public_ip_on_launch = true
  cidr_block = "192.168.2.0/24"

  availability_zone = data.aws_availability_zones.azs.names[1]

  tags = {
    Name = "${var.stack}-public-2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.vpc.id
  #map_public_ip_on_launch = true
  cidr_block = "192.168.3.0/24"

  availability_zone = data.aws_availability_zones.azs.names[2]

  tags = {
    Name = "${var.stack}-public-3"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.10.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name = "${var.stack}-private-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.20.0/24"

  availability_zone = data.aws_availability_zones.azs.names[1]

  tags = {
    Name = "${var.stack}-private-2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.30.0/24"
  availability_zone = data.aws_availability_zones.azs.names[2]

  tags = {
    Name = "${var.stack}-private-3"
  }
}