resource "aws_elasticache_subnet_group" "default" {
  name = "${var.environment}-${var.project}-cache-subnet-default"
  description = "Associate cache with correct VPC"
  subnet_ids = [
    "${aws_subnet.zone_c.id}",
    "${aws_subnet.zone_b.id}"
  ]
}

resource "aws_elasticache_cluster" "memcached" {
    cluster_id = "${var.environment}-${var.project}"
    engine = "memcached"
    node_type = "cache.m1.small"
    port = 11211
    num_cache_nodes = 1
    parameter_group_name = "default.memcached1.4"
    subnet_group_name = "${aws_elasticache_subnet_group.default.name}"
    security_group_ids = [
      "${aws_security_group.default.id}"
    ]
    apply_immediately = true
    tags {
      Name = "${var.environment}-${var.project}-cache-memcached"
      type = "cache"
      project = "${var.project}"
      environment = "${var.environment}"
    }
}
