# Private Database Subnets
variable "private_db_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

# RDS Security Group
variable "rds_sg_id" {
  description = "Security Group ID for PostgreSQL RDS"
  type        = string
}

# RDS Instance Type
variable "db_instance_class" {
  description = "Instance class for PostgreSQL RDS"
  type        = string
}

# PostgreSQL Password
variable "db_password" {
  description = "Master password for PostgreSQL"
  type        = string
  sensitive   = true
}
