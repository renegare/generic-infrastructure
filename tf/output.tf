output "environment" {
    value = "${var.environment}"
}

output "version" {
    value = "${var.version}"
}

output "project" {
    value = "${var.project}"
}

output "ecs_cluster" {
    value = "${aws_ecs_cluster.main.id}"
}

output "desired_instances" {
    value = "${var.desired_instances}"
}

output "min_instances" {
    value = "${var.min_instances}"
}

output "max_instances" {
    value = "${var.max_instances}"
}

output "dns_name" {
    value = "${aws_elb.main.dns_name}"
}

output "proxy_port" {
    value = "${aws_elb.main.proxy_port}"
}

output "healthcheck_port" {
    value = "${aws_elb.main.healthcheck_port}"
}

output "db_name" {
    value = "${var.db_name}"
}

output "db_user" {
    value = "${var.db_user}"
}

output "db_pass" {
    value = "${var.db_pass}"
}

output "db_host" {
    value = "${aws_db_instance.mysql.address}"
}

output "bastion" {
  value = "${aws_instance.bastion.public_ip}"
}

output "memcached" {
  value = "${aws_elasticache_cluster.memcached.cache_nodes.0.address}"
}
