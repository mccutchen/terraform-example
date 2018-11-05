resource "aws_elasticache_subnet_group" "cache" {
  name       = "cache-subnet-group-${var.env}"
  subnet_ids = ["${aws_subnet.public.id}", "${aws_subnet.private.id}"]
}

resource "aws_elasticache_cluster" "cache" {
  cluster_id = "cache-${var.env}"

  engine               = "redis"
  engine_version       = "3.2.6"
  parameter_group_name = "default.redis3.2"

  node_type       = "cache.t2.small"
  num_cache_nodes = 1

  subnet_group_name  = "${aws_elasticache_subnet_group.cache.id}"
  security_group_ids = ["${aws_security_group.cache.id}"]

  tags {
    Name = "cache-${var.env}"
    env  = "${var.env}"
  }
}
