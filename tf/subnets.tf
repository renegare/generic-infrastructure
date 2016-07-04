
/* Public subnets */
resource "aws_subnet" "zone_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.0.64/26" /* ~64 IP Addresses */
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.main"]
  tags {
    Name = "${var.environment}-${var.project}-subnet-zone-c"
    type = "subnet"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "zone_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.0.0/26" /* ~64 IP Addresses */
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.main"]
  tags {
    Name = "${var.environment}-${var.project}-subnet-zone-b"
    type = "subnet"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "routing_for_zone_c" {
  subnet_id = "${aws_subnet.zone_c.id}"
  route_table_id = "${aws_route_table.main.id}"
  depends_on = [
    "aws_subnet.zone_c",
    "aws_route_table.main"
  ]
}

resource "aws_route_table_association" "routing_for_zone_b" {
  subnet_id = "${aws_subnet.zone_b.id}"
  route_table_id = "${aws_route_table.main.id}"
  depends_on = [
    "aws_subnet.zone_b",
    "aws_route_table.main"
  ]
}
