/* ECS Global Proxies */

# Entry Proxy (Fixed Port)
resource "template_file" "proxy_task" {
    template = "${file("service/proxy.json")}"
    vars {
      image = "${var.proxy_image_version}"
      proxy_port = "${var.proxy_port}"
      healthcheck_port = "${var.healthcheck_port}"
    }
}

resource "aws_ecs_task_definition" "proxy" {
  family = "proxy-${var.environment}-${var.project}-task"
  container_definitions = "${template_file.proxy_task.rendered}"
}

resource "aws_ecs_service" "proxy" {
  name = "proxy-${var.environment}-${var.project}-service"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.proxy.arn}"
  desired_count = "${var.desired_instances}"
  iam_role = "${aws_iam_role.ecs_elb.arn}"
  depends_on = ["aws_iam_policy_attachment.ecs_elb"]
  load_balancer {
    elb_name = "${aws_elb.main.id}"
    container_name = "proxy"
    container_port = "${var.proxy_port}"
  }
}

# Webservices Proxy

resource "template_file" "webservices_task" {
    template = "${file("service/webservices.json")}"
    vars {
      image = "${var.proxy_image_version}"
    }
}

resource "template_file" "certbot_task" {
    template = "${file("service/certbot.json")}"
}

resource "aws_ecs_task_definition" "webservices" {
  family = "webservices-${var.environment}-${var.project}-task"
  container_definitions = "${template_file.webservices_task.rendered}"
  /*container_definitions = "${template_file.certbot_task.rendered}"*/
}

resource "aws_ecs_service" "webservices" {
  name = "webservices-${var.environment}-${var.project}-service"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.webservices.arn}"
  desired_count = "${var.desired_instances}"
}
