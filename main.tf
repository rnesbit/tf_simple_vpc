# tf_simple_vpc/main.tf

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Terraform = "true"
    Name = "${var.environment}-vpc"
  }
}

# gateways

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Terraform = "true"
    Name = "${var.environment}-igw"
  }
}

resource "aws_eip" "ngw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {

  allocation_id = "${aws_eip.ngw_eip.id}"
  subnet_id     = "${aws_subnet.public.id}"
}

# routes

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Terraform = "true"
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Terraform = "true"
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.ngw.id}"
}

# subnets

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags {
    Terraform = "true"
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnet}"
  map_public_ip_on_launch = "false"

  tags {
    Terraform = "true"
    Name = "${var.environment}-private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private_rt.id}"
}

# security groups

resource "aws_security_group" "public" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "${var.environment}-public"
  description = "Allow SSH to public"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-public-sg"
  }
}

resource "aws_security_group" "private" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "${var.environment}-private-sg"
  description = "Allow traffic from public"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${aws_security_group.public.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-private-sg"
  }
}


# bastion host

resource "aws_instance" "bastion" {
  ami                         = "${lookup(var.bastion_ami, var.region)}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.public.id}"]
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = true

  tags {
    Terraform = "true"
    Name = "${var.environment}-bastion"
  }
}
