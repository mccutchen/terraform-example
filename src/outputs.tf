output "web_private_ip" {
  value = "${aws_instance.web.*.private_ip}"
}

output "web_private_dns" {
  value = "${aws_instance.web.*.private_dns}"
}

output "web_public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "web_public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}

output "db_address" {
  value = "${aws_db_instance.db.address}"
}

output "db_endpoint" {
  value = "${aws_db_instance.db.endpoint}"
}

output "db_port" {
  value = "${aws_db_instance.db.port}"
}

output "cache_address" {
  value = "${aws_elasticache_cluster.cache.cache_nodes.0.address}"
}
