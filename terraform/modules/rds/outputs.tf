# RDS Endpoint
output "rds_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres.endpoint
}

# RDS Port
output "rds_port" {
  description = "PostgreSQL port"
  value       = aws_db_instance.postgres.port
}

# Database Name
output "rds_db_name" {
  description = "PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}

output "rds_address" {
  description = "PostgreSQL hostname without port"
  value       = aws_db_instance.postgres.address
}
