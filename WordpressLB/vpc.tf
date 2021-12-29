data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.stack}-vpc"
  }
}

resource "aws_eip" "eip" {

  vpc = true

  tags = {
    Name = "${var.stack}-nat-ip"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.stack}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.stack}-public"
  }
}

resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.private.id

  subnet_id = aws_subnet.private1.id
}

resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private2.id
}

resource "aws_route_table_association" "private3" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private3.id
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}


resource "aws_db_subnet_group" "mysql" {
  name       = "${var.stack}-subngroup"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]


  tags = {
    Name = "${var.stack}-subnetGroup"
  }
}

resource "aws_nat_gateway" "nat" {
  depends_on = [aws_subnet.public1, aws_subnet.public2, aws_subnet.public3, aws_eip.eip,]
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.eip.id

  tags = {
    Name = "${var.stack}-nat"
  }
}