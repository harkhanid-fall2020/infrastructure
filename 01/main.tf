provider "aws" {
    region = var.region
}

resource "aws_vpc" "vpc_webapp" {
    cidr_block              = var.vpc_cidr
    enable_dns_hostnames    = true
    enable_dns_support      = true
    enable_classiclink_dns_support = true
    assign_generated_ipv6_cidr_block = false
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "subnet1" {
    cidr_block = var.subnets_cidr[0]
    vpc_id = aws_vpc.vpc_webapp.id
    availability_zone = var.subnets_az[0]
    map_public_ip_on_launch = true
    tags ={
        Name = var.subnets_name[0]
    }
}

resource "aws_subnet" "subnet2" {
    cidr_block = var.subnets_cidr[1]
    vpc_id = aws_vpc.vpc_webapp.id
    availability_zone = var.subnets_az[1]
    map_public_ip_on_launch = true
    tags ={
      Name = var.subnets_name[1]
    }
}

resource "aws_subnet" "subnet3" {
    cidr_block = var.subnets_cidr[2]
    vpc_id = aws_vpc.vpc_webapp.id
    availability_zone = var.subnets_az[2]
    map_public_ip_on_launch = true
    tags ={
      Name = var.subnets_name[2]
    }
}

# creating internet gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_webapp.id
  tags = {
    "Name" = var.gateway_name
  }
}

# creating route table
resource "aws_route_table" "web-public-route" {
  vpc_id = aws_vpc.vpc_webapp.id
  route {
      cidr_block = var.public_cidr_route
      gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    "Name" = var.route_table_name
  }
}

# creating routes for subnets

resource "aws_route_table_association" "artp1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.web-public-route.id
}

resource "aws_route_table_association" "artp2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.web-public-route.id
}

resource "aws_route_table_association" "artp3" {
  subnet_id = aws_subnet.subnet3.id
  route_table_id = aws_route_table.web-public-route.id
}
