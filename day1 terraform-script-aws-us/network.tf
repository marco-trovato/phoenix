locals {
  vpc_name            = var.vpc_name
  private_subnet_name = "${var.subnet_name}-private"
  public_subnet_name  = "${var.subnet_name}-public"
}

data "aws_availability_zones" "AZ" {
  state = "available"
}

## VPC ################# 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.vpc_name
  }
}


#Private subnet ###############
resource "aws_subnet" "private" {
  count                   = var.availability_zones
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = cidrsubnet(var.public_subnet_cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.AZ.names[count.index]

  tags = {
    Name = local.private_subnet_name
  }
}

#Public subnet ##############
resource "aws_subnet" "public" {
  count                   = var.availability_zones
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.private_subnet_cidr_block, 4, count.index) #"10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.AZ.names[count.index]

  tags = {
    Name = local.public_subnet_name
  }
}


#Public Route table ###############
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}


#To avoid the conflict with  the main table
resource "aws_route_table_association" "public" {
  count          = var.availability_zones
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet gateway"
  }
}

# NAT gateway 
resource "aws_nat_gateway" "gw" {

  subnet_id     = element(aws_subnet.public.*.id, 0)
  allocation_id = aws_eip.gw.id

  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "ssm-nat-gateway"
  }
}

resource "aws_eip" "gw" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

#Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "route-table"
  }
}


resource "aws_route_table_association" "private" {
  count          = var.availability_zones
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}