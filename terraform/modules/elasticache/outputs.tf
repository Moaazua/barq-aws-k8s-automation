output "primary_endpoint" {
  description = "ElastiCache Redis primary endpoint"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "port" {
  description = "ElastiCache Redis port"
  value       = aws_elasticache_replication_group.main.port
}