resource "aws_db_subnet_group" "default" {
    name = "${var.environment}-${var.project}-db-subnet-default"
    description = "Associate db with correct VPC"
    subnet_ids = [
      "${aws_subnet.zone_c.id}",
      "${aws_subnet.zone_b.id}"
    ]
    tags {
      Name = "${var.environment}-${var.project}-db-subnet-default"
      type = "db-subnet"
      project = "${var.project}"
      environment = "${var.environment}"
    }
}

resource "aws_db_instance" "mysql" {
  identifier           = "${var.environment}-${var.project}-db-mysql"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.6"
  instance_class       = "db.t2.medium"
  name                 = "${var.db_name}"
  username             = "${var.db_user}"
  password             = "${var.db_pass}"
  port                    = 3306
  vpc_security_group_ids = [
    "${aws_security_group.default.id}"
  ]

  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  apply_immediately = true
  publicly_accessible = false

  tags {
    Name = "${var.environment}-${var.project}-db-mysql"
    type = "db"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}
