#ecs config stuff

resource "template_file" "ecs_config" {
    template = "${file("ecs.config")}"
    vars {
      cluster_name = "${aws_ecs_cluster.main.name}"
    }
}

resource "aws_s3_bucket_object" "ecs_config" {
  bucket = "${var.infra_state_bucket}"
  key = "ecs.config"
  content = "${template_file.ecs_config.rendered}"
  etag = "${md5(template_file.ecs_config.rendered)}"
}
