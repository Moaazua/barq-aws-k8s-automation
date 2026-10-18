# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "barq-elasticache-subnet-group"
  subnet_ids = var.private_subnet_ids

  description = "Private subnets for BARQ ElastiCache"
}

# ElastiCache Redis OSS
resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "barq-elasticache"
  description          = "Managed Redis for BARQ application"

  engine         = "redis"
  engine_version = "7.1"
  node_type      = var.node_type

  num_cache_clusters         = 1
  automatic_failover_enabled = false

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [var.security_group_id]

  port = 6379

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  transit_encryption_mode    = "required"

  auth_token = var.auth_token

  tags = {
    Name = "barq-elasticache"
  }
}