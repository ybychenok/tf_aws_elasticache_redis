output "redis_security_group_ids" {
  value = "${aws_security_group.redis_security_group.*.id}"
}

output "parameter_group" {
  value = "${aws_elasticache_parameter_group.redis_parameter_group.id}"
}

output "redis_subnet_group_name" {
  value = "${aws_elasticache_subnet_group.redis_subnet_group.name}"
}

output "id" {
  value = "${aws_elasticache_replication_group.redis.id}"
}

output "port" {
  value = "${var.redis_port}"
}

output "endpoint" {
  value = "${aws_elasticache_replication_group.redis.primary_endpoint_address}"
}

output "custom_redis_sg" {
  value = "${var.custom_redis_sg}"
}

output "allowed_security_groups" {
  value = "${var.allowed_security_groups}"
}

output "allowed_sgs_str" {
  value = "${local.allowed_sgs_str}"
}

output "allowed_sgs" {
  value = "${local.allowed_sgs}"
}
