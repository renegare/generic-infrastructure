/* Autoscaling and EC2 management */
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.project}-ecs-cluster"
}

resource "template_file" "user_data" {
    template = "${file("user-data")}"
    vars {
        infra_state_bucket = "${var.infra_state_bucket}"
    }
}

resource "aws_key_pair" "root_key" {
  key_name = "${var.environment}-${var.project}-root-key"
  public_key = "${file(var.ec2_public_key)}"
}

resource "aws_launch_configuration" "cluster_conf" {
  name_prefix = "${var.environment}-${var.project}-cluster-conf-"
  instance_type = "${var.instance_type}"
  image_id = "${lookup(var.ami, var.region)}"
  associate_public_ip_address = false
  depends_on = [
    "aws_iam_instance_profile.profile",
    "aws_s3_bucket_object.ecs_config"
  ]
  iam_instance_profile = "${aws_iam_instance_profile.profile.id}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.public.id}"
  ]
  user_data = "${template_file.user_data.rendered}"
  key_name = "${aws_key_pair.root_key.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cluster" {
  name = "${var.environment}-${var.project}-cluster"
  vpc_zone_identifier = [
    "${aws_subnet.zone_c.id}",
    "${aws_subnet.zone_b.id}"
  ]
  min_size = "${var.min_instances}"
  max_size = "${var.max_instances}"
  desired_capacity =  "${var.desired_instances}"
  launch_configuration = "${aws_launch_configuration.cluster_conf.name}"
  health_check_type = "EC2"
  depends_on = ["aws_launch_configuration.cluster_conf"]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key = "Name"
    value = "${var.environment}-${var.project}-cluster"
    propagate_at_launch = true
  }
  tag {
    key = "type"
    value = "ec2"
    propagate_at_launch = true
  }
  tag {
    key = "project"
    value = "${var.project}"
    propagate_at_launch = true
  }
  tag {
    key = "environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key = "type"
    value = "cluster"
    propagate_at_launch = false
  }
}
