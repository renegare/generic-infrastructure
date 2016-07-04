
/* Security Groups */
resource "aws_security_group" "default" {
  name = "${var.environment}-${var.project}-sg-default"
  description = "Default security group that allows inbound and outbound traffic between instances within the VPC"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags {
    Name = "${var.environment}-${var.project}-sg-default"
    type = "sg"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}

resource "aws_security_group" "public" {
  name = "${var.environment}-${var.project}-sg-public"
  description = "Security group for public facing instances that allows SSH, HTTP and HTTPS traffic from internet."
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.environment}-${var.project}-sg-public"
    type = "sg"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}
