data "aws_availability_zones" "available" {}

resource "aws_vpc" "project_vpc" {
  cidr_block           = "${var.vpc_ips}"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "${var.name_of_deploy}_vpc"
  }
}

resource "aws_internet_gateway" "project_igw" {
  vpc_id = "${aws_vpc.project_vpc.id}"

  tags = {
    Name = "${var.name_of_deploy}_igw"
  }
}

resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.az_count}"
}

resource "aws_nat_gateway" "project_nat" {
  count         = length(aws_subnet.project_public_subnet)
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id     = "${aws_subnet.project_public_subnet.*.id[count.index]}"

  tags = {
    Name = "${var.name_of_deploy}_nat"
  }
}


resource "aws_route_table" "public_routes" {
  vpc_id = "${aws_vpc.project_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.project_igw.id}"
  }
  tags = {
    Name = "${var.name_of_deploy}_public_route"
  }
}

resource "aws_route_table" "private_routes" {
  count = "${var.az_count}"
  vpc_id = "${aws_vpc.project_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.project_nat.*.id[count.index]}"
  }

  tags = {
    Name = "private_routes"
  }
}

resource "aws_subnet" "project_public_subnet" {
  count                   = "${var.az_count}"
  vpc_id                  = "${aws_vpc.project_vpc.id}"
  cidr_block              = "${var.public_ips[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "project_private_subnet" {
  count                   = "${var.az_count}"
  vpc_id                  = "${aws_vpc.project_vpc.id}"
  cidr_block              = "${var.private_ips[count.index]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "project_public_associations" {
  count          = length(aws_subnet.project_public_subnet)
  subnet_id      = "${aws_subnet.project_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_route_table_association" "project_private_associations" {
  count          = length(aws_subnet.project_private_subnet)
  subnet_id      = "${aws_subnet.project_private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_routes.*.id[count.index]}"
}

