output "control_plane_sg_id" {
  description = "Security Group ID for Control Plane"
  value       = aws_security_group.control_plane.id
}

output "worker_sg_id" {
  description = "Security Group ID for Worker Node"
  value       = aws_security_group.worker.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS PostgreSQL"
  value       = aws_security_group.rds.id
}