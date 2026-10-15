# Control Plane Outputs
output "control_plane_instance_id" {
  description = "Control Plane EC2 Instance ID"
  value       = aws_instance.control_plane.id
}

output "control_plane_public_ip" {
  description = "Control Plane Public IP"
  value       = aws_instance.control_plane.public_ip
}

output "control_plane_private_ip" {
  description = "Control Plane Private IP"
  value       = aws_instance.control_plane.private_ip
}

# Worker Outputs
output "worker_instance_id" {
  description = "Worker EC2 Instance ID"
  value       = aws_instance.worker.id
}

output "worker_public_ip" {
  description = "Worker Public IP"
  value       = aws_instance.worker.public_ip
}

output "worker_private_ip" {
  description = "Worker Private IP"
  value       = aws_instance.worker.private_ip
}