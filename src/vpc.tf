# =============================================================================
# vpc
# =============================================================================
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "vpc-${var.env}"
    env  = "${var.env}"
  }
}

# =============================================================================
# subnets
# =============================================================================
resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "${local.public_az}"

  tags {
    Name = "subnet-public-${var.env}"
    env  = "${var.env}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "${local.private_az}"

  tags {
    Name = "subnet-private-${var.env}"
    env  = "${var.env}"
  }
}

# =============================================================================
# routing
# =============================================================================
resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "gateway-${var.env}"
    env  = "${var.env}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    Name = "rt-public-${var.env}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# =============================================================================
# security groups
# =============================================================================
resource "aws_security_group" "web" {
  name        = "web-${var.env}"
  description = "Allow incoming HTTP & SSH connections and all outbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags {
    Name = "web-${var.env}"
    env  = "${var.env}"
  }
}

resource "aws_security_group" "db" {
  name        = "db-${var.env}"
  description = "Allow mysql connections from public subnet"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  tags {
    Name = "db-${var.env}"
    env  = "${var.env}"
  }
}

resource "aws_security_group" "cache" {
  name        = "cache-${var.env}"
  description = "Allow redis connections from public subnet"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  tags {
    Name = "cache-${var.env}"
    env  = "${var.env}"
  }
}
