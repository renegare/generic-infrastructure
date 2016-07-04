provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.access_secret}"
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24" /* ~256 IP addresses */
  tags {
    Name = "${var.environment}-${var.project}-vpc"
    type = "vpc"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.environment}-${var.project}-gateway"
    type = "gateway"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
    Name = "${var.environment}-${var.project}-routing"
    type = "routing"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}
