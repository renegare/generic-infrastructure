resource "aws_elb" "main" {
  name = "${var.environment}-${var.project}-elb"
  subnets = [
    "${aws_subnet.zone_c.id}",
    "${aws_subnet.zone_b.id}"
  ]
  connection_draining = true
  cross_zone_load_balancing = true
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.public.id}"
  ]

  listener {
    instance_port = "${var.proxy_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = "${var.proxy_port}"
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.main.arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    target = "HTTP:${var.healthcheck_port}/healthcheck"
    interval = 5
    timeout = 4
  }

  tags {
    Name = "${var.environment}-${var.project}-elb"
    type = "elb"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}
